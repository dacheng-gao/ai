# AI Guidance

A source repository for globally installed Claude Code and Codex guidance.
`AGENTS.md` is the shared global working agreement, not a separate project policy.
The repository is not intended to be copied into each business project.

The agreement keeps stable scope, authority, evidence, and communication defaults.
Skills add task-specific decisions and checks only when their descriptions match.
Clear tasks proceed directly; requirements analysis, alternative designs, extra
tests, and delegation apply when they resolve actual uncertainty or risk.

## Layout

- `AGENTS.md`: the single shared global agreement
- `CLAUDE.md`: Claude Code entry point importing that agreement
- `.agents/skills/`: 6 reusable skills, including guidance evaluation
- `.codex/hooks/`: Codex prompt review hook script
- `docs/`: methodology, design rationale, and behavioral evaluation cases
- `prompts/`: optional user-invoked analysis prompts

Engineering and communication defaults are consolidated into `AGENTS.md`.
This repository no longer distributes separate Markdown rules or agent roles.
Existing external skills, rules, and host-specific agents remain user-owned.
Delegation uses capabilities exposed by the active host; installed role counts
are not evidence that delegation will improve a task.

## Usage And Verification

Skills live in `.agents/skills/`, including their reference files and host metadata.
The former installer and verification scripts have been removed. Global guidance
and skill installations must be managed separately; updating this checkout does
not update existing installed copies.

The prompt review script is stored at [`.codex/hooks/prompt-review.mjs`](.codex/hooks/prompt-review.mjs).
It uses Node.js built-ins and handles `SessionStart`, `UserPromptSubmit`, and
`Stop` events. This repository copy preserves the current global script's behavior;
global hook registration is managed separately.

Check script syntax with:

```bash
node --check .codex/hooks/prompt-review.mjs
```

Check the active host's skill list to confirm runtime discovery. File presence
and syntax checks do not prove that guidance improves model behavior. Use
[the evaluation cases](docs/guidance-evaluation.md) and
[`evaluate-guidance`](.agents/skills/evaluate-guidance/SKILL.md) to compare outcomes.
See [design decisions and evidence](docs/guidance-design.md) for trade-offs and limits.

## Codex resilient runner

[`codex_resilient.py`](tools/codex-resilient/codex_resilient.py) is an external retry and resume
supervisor for the local `~/bin/codex-*` wrappers. It uses `codex exec --json`,
persists each run under `~/.codex-resilient/runs`, and resumes the same session
after capacity, rate-limit, or transient network failures. Permanent errors and
user interrupts stop without retrying.

The global entry point is installed at `~/bin/codex-resilient`:

```bash
codex-resilient --profile dacheng --max-attempts 99 --max-elapsed 24h \
  "完成这个任务"
```

Use `--wrapper ~/bin/codex-halcrow` when the wrapper itself, rather than the
profile name, is the source of truth. The runner does not copy credentials from
wrappers and never uses `--ephemeral`, because session persistence is required
for resume.

## License

[MIT](LICENSE)
