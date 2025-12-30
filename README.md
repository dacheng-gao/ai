# AI Agent Instructions

Reusable rules and skills for AI-assisted development.

> You maybe interested in superpowers: https://github.com/obra/superpowers

## Install

Clone this repo into your home directory:

```sh
git clone https://github.com/dacheng-gao/ai ~/.ai
```

## Configure Global Rules

```md
## Global Rules

<EXTREMELY_IMPORTANT>
You MUST always read and follow instructions from `~/.ai/AGENTS.md`.
</EXTREMELY_IMPORTANT>
```

Add the above to:

- `~/.codex/AGENTS.md`
- `~/.claude/CLAUDE.md`
- `~/.gemini/GEMINI.md`

## Install Skills

For Codex:

```sh
cp -r ~/.ai/skills/* ~/.codex/skills
```

For Claude:

```sh
cp -r ~/.ai/skills/* ~/.claude/skills
```

## Bonus !!!

We can use `superpowers` in Antigravity along with Claude models.

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

Simply copy / paste above to `~/.gemini/GEMINI.md`, and it just works!