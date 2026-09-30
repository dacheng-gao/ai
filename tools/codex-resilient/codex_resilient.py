#!/usr/bin/env python3
"""Session-aware retry supervisor for Codex CLI wrappers."""

from __future__ import annotations

import argparse
import json
import os
import random
import re
import selectors
import signal
import subprocess
import sys
import tempfile
import time
import uuid
from pathlib import Path
from typing import Any


TRANSIENT_PATTERNS = (
    r"at capacity",
    r"rate limit",
    r"too many requests",
    r"\b429\b",
    r"\b408\b",
    r"\b5\d\d\b",
    r"timeout",
    r"timed out",
    r"connection (?:reset|refused|closed)",
    r"temporarily unavailable",
    r"service unavailable",
    r"network is unreachable",
    r"name or service not known",
)
PERMANENT_PATTERNS = (
    r"\b401\b",
    r"\b403\b",
    r"invalid (?:api )?key",
    r"authentication failed",
    r"unknown model",
    r"invalid .*config",
    r"profile .*not found",
    r"no such file or directory",
    r"permission denied",
)


def classify_error(text: str, returncode: int) -> str:
    """Classify a failed attempt using output and exit status."""
    lowered = text.lower()
    if any(re.search(pattern, lowered) for pattern in PERMANENT_PATTERNS):
        return "permanent"
    if any(re.search(pattern, lowered) for pattern in TRANSIENT_PATTERNS):
        return "transient"
    # Signals are handled separately; an unknown non-zero result is not safe to retry.
    return "unknown" if returncode else "success"


def backoff(attempt: int, initial: float, maximum: float, jitter: float, rng=random) -> float:
    base = min(maximum, initial * (2 ** max(0, attempt - 1)))
    return base * (1 + rng.uniform(-jitter, jitter))


def find_wrapper(profile: str | None, wrapper: str | None) -> Path:
    if bool(profile) == bool(wrapper):
        raise ValueError("exactly one of --profile or --wrapper is required")
    if profile:
        if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9_-]*", profile):
            raise ValueError("invalid profile name")
        candidate = Path.home() / "bin" / f"codex-{profile}"
    else:
        candidate = Path(os.path.expanduser(wrapper or ""))
    candidate = candidate.resolve()
    if not candidate.is_file() or not os.access(candidate, os.X_OK):
        raise ValueError(f"wrapper is not an executable file: {candidate}")
    if candidate.name.startswith("codex-") is False:
        raise ValueError("wrapper must be named codex-* for safety")
    return candidate


def atomic_json(path: Path, value: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as handle:
            json.dump(value, handle, ensure_ascii=False, indent=2)
            handle.write("\n")
            handle.flush()
            os.fsync(handle.fileno())
        os.chmod(temporary, 0o600)
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def find_session_id(value: Any) -> str | None:
    if isinstance(value, dict):
        for key in ("thread_id", "session_id", "conversation_id"):
            item = value.get(key)
            if isinstance(item, str) and item:
                return item
        for item in value.values():
            found = find_session_id(item)
            if found:
                return found
    elif isinstance(value, list):
        for item in value:
            found = find_session_id(item)
            if found:
                return found
    return None


def parse_elapsed(value: str) -> float:
    match = re.fullmatch(r"\s*(\d+(?:\.\d+)?)\s*(s|m|h|d)?\s*", value, re.I)
    if not match:
        raise argparse.ArgumentTypeError("duration must look like 30s, 15m, 2h, or 1d")
    number = float(match.group(1))
    return number * {None: 1, "s": 1, "m": 60, "h": 3600, "d": 86400}[match.group(2).lower() if match.group(2) else None]


class Supervisor:
    def __init__(self, args: argparse.Namespace, wrapper: Path, prompt: str):
        self.args = args
        self.wrapper = wrapper
        self.prompt = prompt
        self.run_id = uuid.uuid4().hex
        self.state_dir = Path(os.path.expanduser(args.state_dir)).resolve() / self.run_id
        self.state_dir.mkdir(parents=True, mode=0o700)
        self.state_path = self.state_dir / "state.json"
        self.state: dict[str, Any] = {
            "run_id": self.run_id,
            "wrapper": str(wrapper),
            "profile": wrapper.name.removeprefix("codex-"),
            "cwd": str(args.cwd),
            "attempt": 0,
            "status": "starting",
            "session_id": None,
            "started_at": time.time(),
        }
        atomic_json(self.state_path, self.state)
        (self.state_dir / "prompt.txt").write_text(prompt, encoding="utf-8")
        os.chmod(self.state_dir / "prompt.txt", 0o600)
        self.child: subprocess.Popen[bytes] | None = None
        self.stop_requested = False

    def stop(self, *_signal: object) -> None:
        self.stop_requested = True
        if self.child and self.child.poll() is None:
            self.child.terminate()

    def command(self, attempt: int, resume: bool) -> list[str]:
        output = self.state_dir / f"attempt-{attempt:03d}.last-message"
        command = [str(self.wrapper), "-C", str(self.args.cwd), "exec"]
        if resume:
            command += ["resume", "--json", "-o", str(output), str(self.state["session_id"]), "-"]
        else:
            command += ["--json", "--color", "never", "-o", str(output), "-"]
        return command

    def run_child(self, command: list[str], attempt: int, message: str) -> tuple[int, str]:
        stdout_path = self.state_dir / f"attempt-{attempt:03d}.jsonl"
        stderr_path = self.state_dir / f"attempt-{attempt:03d}.stderr"
        self.state["status"] = "running"
        atomic_json(self.state_path, self.state)
        with stdout_path.open("wb", buffering=0) as stdout_file, stderr_path.open("wb", buffering=0) as stderr_file:
            self.child = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=self.args.cwd)
            assert self.child.stdin and self.child.stdout and self.child.stderr
            self.child.stdin.write(message.encode("utf-8"))
            self.child.stdin.close()
            selector = selectors.DefaultSelector()
            selector.register(self.child.stdout, selectors.EVENT_READ, (stdout_file, True))
            selector.register(self.child.stderr, selectors.EVENT_READ, (stderr_file, False))
            captured: list[str] = []
            stdout_buffer = ""
            while selector.get_map():
                for key, _ in selector.select(timeout=0.5):
                    chunk = os.read(key.fd, 65536)
                    if not chunk:
                        selector.unregister(key.fileobj)
                        continue
                    destination, is_stdout = key.data
                    destination.write(chunk)
                    captured.append(chunk.decode("utf-8", errors="replace"))
                    if is_stdout:
                        stdout_buffer += chunk.decode("utf-8", errors="replace")
                        lines = stdout_buffer.splitlines(keepends=True)
                        stdout_buffer = lines.pop() if lines and not lines[-1].endswith(("\n", "\r")) else ""
                        for line in lines:
                            try:
                                event = json.loads(line)
                            except json.JSONDecodeError:
                                continue
                            session_id = find_session_id(event)
                            if session_id and not self.state.get("session_id"):
                                self.state["session_id"] = session_id
                                atomic_json(self.state_path, self.state)
                    target = sys.stdout.buffer if is_stdout else sys.stderr.buffer
                    target.write(chunk)
                    target.flush()
            if stdout_buffer:
                try:
                    event = json.loads(stdout_buffer)
                except json.JSONDecodeError:
                    event = None
                session_id = find_session_id(event) if event is not None else None
                if session_id and not self.state.get("session_id"):
                    self.state["session_id"] = session_id
                    atomic_json(self.state_path, self.state)
            returncode = self.child.wait()
        self.child = None
        return returncode, "".join(captured)

    def run(self) -> int:
        start = time.monotonic()
        previous_error = ""
        for attempt in range(1, self.args.max_attempts + 1):
            if self.stop_requested:
                break
            self.state["attempt"] = attempt
            resume = bool(self.state.get("session_id"))
            message = self.args.resume_message if resume else self.prompt
            command = self.command(attempt, resume)
            returncode, output = self.run_child(command, attempt, message)
            if returncode == 0:
                self.state["status"] = "succeeded"
                atomic_json(self.state_path, self.state)
                return 0
            if self.stop_requested:
                break
            classification = classify_error(output, returncode)
            self.state["last_error_class"] = classification
            previous_error = output[-2000:]
            if classification != "transient":
                self.state["status"] = "failed"
                atomic_json(self.state_path, self.state)
                print(f"codex-resilient: stopping after {classification} error; run state: {self.state_path}", file=sys.stderr)
                return returncode or 1
            if attempt >= self.args.max_attempts or time.monotonic() - start >= self.args.max_elapsed:
                break
            delay = backoff(attempt, self.args.initial_delay, self.args.max_delay, self.args.jitter)
            remaining = self.args.max_elapsed - (time.monotonic() - start)
            delay = min(delay, max(0, remaining))
            self.state["status"] = "waiting"
            self.state["next_retry_at"] = time.time() + delay
            atomic_json(self.state_path, self.state)
            print(f"codex-resilient: transient error; retry {attempt + 1}/{self.args.max_attempts} in {delay:.1f}s", file=sys.stderr)
            time.sleep(delay)
        self.state["status"] = "stopped" if self.stop_requested else "exhausted"
        atomic_json(self.state_path, self.state)
        if previous_error:
            print(f"codex-resilient: final diagnostic: {previous_error[-500:]}", file=sys.stderr)
        print(f"codex-resilient: run state: {self.state_path}", file=sys.stderr)
        return 130 if self.stop_requested else 1


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser(description="Retry and resume Codex exec sessions safely.")
    group = result.add_mutually_exclusive_group(required=True)
    group.add_argument("--wrapper", help="Executable ~/bin/codex-* wrapper")
    group.add_argument("--profile", help="Profile resolved as ~/bin/codex-<profile>")
    result.add_argument("--cwd", default=os.getcwd(), type=lambda p: str(Path(p).expanduser().resolve()))
    result.add_argument("--state-dir", default="~/.codex-resilient/runs")
    result.add_argument("--max-attempts", type=int, default=99)
    result.add_argument("--max-elapsed", type=parse_elapsed, default=86400.0)
    result.add_argument("--initial-delay", type=float, default=15.0)
    result.add_argument("--max-delay", type=float, default=300.0)
    result.add_argument("--jitter", type=float, default=0.2)
    result.add_argument("--resume-message", default="上一次请求因临时错误中断。请检查当前工作区和已有修改，继续原任务，不要重复已完成的工作。")
    result.add_argument("prompt", nargs="?", help="Task prompt; if omitted, read stdin")
    return result


def main(argv: list[str] | None = None) -> int:
    args = parser().parse_args(argv)
    if args.max_attempts < 1 or args.max_elapsed <= 0 or not 0 <= args.jitter <= 1:
        parser().error("max-attempts/max-elapsed must be positive and jitter must be in [0, 1]")
    try:
        wrapper = find_wrapper(args.profile, args.wrapper)
    except ValueError as error:
        parser().error(str(error))
    if not Path(args.cwd).is_dir():
        parser().error(f"cwd is not a directory: {args.cwd}")
    prompt = args.prompt if args.prompt is not None else sys.stdin.read()
    if not prompt.strip():
        parser().error("prompt is empty")
    supervisor = Supervisor(args, wrapper, prompt)
    signal.signal(signal.SIGINT, supervisor.stop)
    signal.signal(signal.SIGTERM, supervisor.stop)
    return supervisor.run()


if __name__ == "__main__":
    raise SystemExit(main())
