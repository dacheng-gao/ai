# AI Agent Instructions

Reusable rules and skills for AI-assisted development.

> **Prerequisite:** Set up [Superpowers](https://github.com/obra/superpowers) first.

## Quick Start

Clone this repo to your home directory:

```sh
git clone https://github.com/dacheng-gao/ai ~/.ai
```

Then follow the setup instructions for your AI tool below.

---

## Codex

### Configure Global Rules

Add the following to `~/.codex/AGENTS.md`:

```md
## Global Rules

<EXTREMELY_IMPORTANT>
You MUST always read and follow instructions from `~/.ai/AGENTS.md`.
</EXTREMELY_IMPORTANT>
```

### Install Skills

```shell
cp -r ~/.ai/skills/* ~/.codex/skills/
```

---

## Claude Code

### Configure Global Rules

Add the following to `~/.claude/CLAUDE.md`:

```md
## Global Rules

<EXTREMELY_IMPORTANT>
You MUST always read and follow instructions from `~/.ai/AGENTS.md`.
</EXTREMELY_IMPORTANT>
```

### Create Symlink for Rules

Claude Code cannot resolve relative paths specified in `~/.ai/AGENTS.md`, so create a symlink:

```shell
ln -s ~/.ai/rules ~/.claude/rules
```

### Install Skills

```shell
cp -r ~/.ai/skills/* ~/.claude/skills/
```

---

## Antigravity

> **Note:** This reuses Codex settings.

Complete the Codex setup first, then add the following to `~/.gemini/GEMINI.md`:

```md
## Superpowers System

<EXTREMELY_IMPORTANT>
You have superpowers. Superpowers teach you new skills and capabilities. RIGHT NOW run: `~/.codex/superpowers/.codex/superpowers-codex bootstrap` and follow the instructions it returns.
</EXTREMELY_IMPORTANT>

## Global Rules

<EXTREMELY_IMPORTANT>
You MUST always read and follow instructions from `~/.ai/AGENTS.md`.
</EXTREMELY_IMPORTANT>
```

---

## License

[MIT](LICENSE)
