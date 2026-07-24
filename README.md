# AI Guidance

Shared baseline guidance for Claude Code and Codex.

This repository assumes a capable host model and a separately installed
[superpowers](https://github.com/obra/superpowers) plugin. It adds only:

- a short, host-neutral engineering constitution;
- concise global engineering and communication defaults;
- domain skills for repository work, Git, GitHub, review, requirements, and test
  design;
- small optional Claude Code subagent definitions and host-neutral delegation
  guidance.

Generic planning, debugging, TDD, review, and verification workflows belong to
the host and superpowers. `superagents` selects a narrowly matched specialist or
coordinates genuinely independent work only when delegation adds material
value; it is not a gateway for every request.

## Layout

- `AGENTS.md`: durable shared principles
- `CLAUDE.md`: thin Claude Code entry point
- `rules/`: short global defaults
- `skills/`: task-triggered domain guidance
- `agents/`: bounded optional Claude Code workers
- `scripts/`: installation and repository verification

## Install

Install superpowers first, then follow:

- Claude Code: [`.claude/INSTALL.md`](.claude/INSTALL.md)
- Codex: [`.codex/INSTALL.md`](.codex/INSTALL.md)

Upgrade instructions are in the corresponding `UPGRADE.md`. The installer
tracks files managed by this repository, removes them when they disappear from
the repository, and preserves unrelated user content.

Codex uses its built-in agents and personal or project custom TOML agents.
Claude Code uses its built-ins plus Markdown agents under `~/.claude/agents`.
Routing uses the agents exposed by the active host and their descriptions; this
repository does not maintain a static catalog of externally installed agents.

## Verify

```bash
bash scripts/verify.sh
```

The check validates active guidance structure, approval-gate invariants, skill
metadata, install documentation, local references, and context-size budgets.

## License

[MIT](LICENSE)
