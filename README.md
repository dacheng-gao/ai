# AI Guidance

Shared baseline guidance for Claude Code and Codex.

This repository assumes a capable host model and a separately installed
[superpowers](https://github.com/obra/superpowers) plugin. It adds only:

- a short, host-neutral engineering constitution;
- concise global engineering and communication defaults;
- domain skills for repository work, Git, GitHub, review, requirements, and test
  design;
- small optional subagent definitions.

Generic planning, debugging, TDD, review, and verification workflows belong to
the host and superpowers. `superagents` is optional coordination for
genuinely cross-lane work, not a gateway for every request.

## Layout

- `AGENTS.md`: durable shared principles
- `CLAUDE.md`: thin Claude Code entry point
- `rules/`: short global defaults
- `skills/`: task-triggered domain guidance
- `agents/`: bounded optional workers
- `scripts/`: installation and repository verification

## Install

Install superpowers first, then follow:

- Claude Code: [`.claude/INSTALL.md`](.claude/INSTALL.md)
- Codex: [`.codex/INSTALL.md`](.codex/INSTALL.md)

Upgrade instructions are in the corresponding `UPGRADE.md`. The
installer removes only known obsolete files managed by this repository and
preserves unrelated user content.

## Verify

```bash
bash scripts/verify.sh
```

The check validates active guidance structure, skill metadata, obsolete
constraints, install documentation, and context-size budgets.

## License

[MIT](LICENSE)
