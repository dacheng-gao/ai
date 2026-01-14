## Superpowers System

<EXTREMELY_IMPORTANT>
MANDATORY FIRST STEP - DO NOT SKIP:

Before responding to ANY user request, you MUST:
1. Run `~/.codex/superpowers/.codex/superpowers-codex bootstrap`
2. Scan for local skills: Check `~/.ai/skills` for `SKILL.md` files.

These steps load essential and custom skills. Without this:
- You will miss critical skills that apply to the user's task
- Your responses will be incomplete or incorrect
- You will fail the user's request

Run bootstrap FIRST, then proceed with the user's request.
</EXTREMELY_IMPORTANT>

## AGENT Rules

<EXTREMELY_IMPORTANT>
MANDATORY SECOND STEP - DO NOT SKIP:

After running bootstrap, you MUST read and follow instructions from `~/.ai/AGENTS.md`.

This file contains global rules that apply to ALL conversations:
- Language rules (response language, code language)
- Output style rules (conciseness, behavior)

Without reading these rules:
- Your responses will not match user expectations
- You will fail the user's request

Read ~/.ai/AGENTS.md NOW and follow its instructions.
</EXTREMELY_IMPORTANT>
