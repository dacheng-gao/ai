import json
import os
import stat
import subprocess
import tempfile
import unittest
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))

import codex_resilient


class UnitTests(unittest.TestCase):
    def test_classifies_capacity_as_transient(self):
        self.assertEqual(codex_resilient.classify_error("Selected model is at capacity", 1), "transient")

    def test_authentication_is_permanent(self):
        self.assertEqual(codex_resilient.classify_error("401 invalid api key", 1), "permanent")

    def test_backoff_is_capped(self):
        self.assertEqual(codex_resilient.backoff(10, 15, 300, 0, rng=type("R", (), {"uniform": lambda *_: 0})()), 300)

    def test_profile_resolves_to_home_bin(self):
        with tempfile.TemporaryDirectory() as directory:
            old_home = os.environ.get("HOME")
            try:
                os.environ["HOME"] = directory
                wrapper = Path(directory) / "bin" / "codex-test"
                wrapper.parent.mkdir()
                wrapper.write_text("#!/bin/sh\nexit 0\n")
                wrapper.chmod(wrapper.stat().st_mode | stat.S_IXUSR)
                self.assertEqual(codex_resilient.find_wrapper("test", None), wrapper.resolve())
            finally:
                if old_home is None:
                    os.environ.pop("HOME", None)
                else:
                    os.environ["HOME"] = old_home


class IntegrationTests(unittest.TestCase):
    def test_capacity_failure_resumes_same_session(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            count = root / "count"
            wrapper = root / "codex-fake"
            wrapper.write_text(
                "#!/bin/sh\n"
                f"count={count}\n"
                "n=0; [ -f \"$count\" ] && n=$(cat \"$count\")\n"
                "n=$((n+1)); printf '%s' \"$n\" > \"$count\"\n"
                "case \"$*\" in\n"
                "  *' resume '*|*' resume --json'*) printf '%s\\n' '{\"type\":\"turn.completed\"}'; exit 0 ;;\n"
                "  *) printf '%s\\n' '{\"thread_id\":\"thread-test\"}'; printf '%s\\n' 'Selected model is at capacity' >&2; exit 1 ;;\n"
                "esac\n"
            )
            wrapper.chmod(wrapper.stat().st_mode | stat.S_IXUSR)
            state = root / "runs"
            result = subprocess.run(
                [
                    "python3", str(Path(__file__).resolve().parent / "codex_resilient.py"), "--wrapper", str(wrapper),
                    "--cwd", directory, "--state-dir", str(state), "--max-elapsed", "30s",
                    "--initial-delay", "0", "--max-delay", "0", "test task",
                ],
                text=True, capture_output=True, check=False,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(count.read_text(), "2")
            run_state = json.loads(next(state.glob("*/state.json")).read_text())
            self.assertEqual(run_state["status"], "succeeded")
            self.assertEqual(run_state["session_id"], "thread-test")


if __name__ == "__main__":
    unittest.main()
