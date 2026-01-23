# AI Agent Instructions

Reusable rules and skills for AI-assisted development.

> **Prerequisite:** Set up [Superpowers](https://github.com/obra/superpowers) first.

## Quick Start

Clone this repo to your home directory:

```sh
git clone https://github.com/dacheng-gao/ai ~/.ai
```

Then follow the setup steps for your AI tool below.

---

## Codex

### Rules

Add this block to `~/.codex/AGENTS.md`:

```md
## Superpowers System

<EXTREMELY_IMPORTANT>
You have superpowers. Superpowers teach you new skills and capabilities. RIGHT NOW run: `~/.codex/superpowers/.codex/superpowers-codex bootstrap` and follow the instructions it returns.
</EXTREMELY_IMPORTANT>

## Session Init

<EXTREMELY_IMPORTANT>
You MUST always invoke the `session-init` skill before responding to any user request.
</EXTREMELY_IMPORTANT>
```

### Skills

Copy the skills directory:

```sh
mkdir -p ~/.codex/skills
cp -r skills/* ~/.codex/skills/
```

---

## Claude Code

### Rules

Claude auto-loads `~/.claude/rules`:

```sh
mkdir -p ~/.claude/rules
cp rules/* ~/.claude/rules/
```

### Skills

Copy the skills directory:

```sh
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/
```

---

## Google Antigravity (Gemini)

### Rules

Add this block to `~/.gemini/GEMINI.md`:

```md
## Superpowers System

<EXTREMELY_IMPORTANT>
You have superpowers. Superpowers teach you new skills and capabilities. RIGHT NOW run: `~/.codex/superpowers/.codex/superpowers-codex bootstrap` and follow the instructions it returns.
</EXTREMELY_IMPORTANT>

<EXTREMELY_IMPORTANT>
You MUST always invoke the `session-init` skill before responding to any user request.
</EXTREMELY_IMPORTANT>
```

### Skills

Copy the skills directory:

```sh
mkdir -p ~/.gemini/antigravity/global_skills
cp -r skills/* ~/.gemini/antigravity/global_skills/
```

---

## License

[MIT](LICENSE)
