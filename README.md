# AI Agent Instructions

Reusable rules and skills for AI-assisted development.

## Install

Clone this repo into your home directory:

```sh
git clone https://github.com/dacheng-gao/ai ~/.ai
```

## Configure Global Rules

Add the following to `~/.codex/AGENTS.md` or `~/.claude/AGENTS.md`:

```md
## Global Rules

<EXTREMELY_IMPORTANT>
You MUST always read and follow instructions from `~/.ai/AGENTS.md`.
</EXTREMELY_IMPORTANT>
```

## Install Skills

For Claude:

```sh
cp -r ~/.ai/skills/* ~/.claude/skills
```

For Codex:

```sh
cp -r ~/.ai/skills/* ~/.codex/skills
```
