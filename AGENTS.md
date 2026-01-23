# AGENTS.md

Reusable rules and skills for AI-assisted development. Clone to `~/.ai` and copy to your AI tool's config directory.

## Project Structure

```
rules/           # Global rules (auto-loaded by agents)
skills/          # Invocable skills (SKILL.md per directory)
README.md        # Installation guide for users
```

## Code Style

- **Language**: Write rules and skills in Chinese (project convention per `rules/language-rules.md`)
- **Technical content**: Keep code examples, git commits, and config in English
- **Format**: Standard Markdown with YAML frontmatter for skills

## Writing Rules

Rules in `rules/` are auto-loaded at session start. Keep them:
- Concise and actionable
- Focused on one concern per file
- Free of tool-specific syntax

## Writing Skills

Each skill is a directory under `skills/` containing `SKILL.md`:

```yaml
---
name: skill-name
description: One-line description for skill matching
---

# Skill Title

## Overview
What this skill does and when to use it.

## Steps
1. First action
2. Second action

## Examples
Show concrete usage.
```

## Validation

Before committing changes:

```bash
# Check markdown syntax
find . -name "*.md" -exec cat {} \; > /dev/null

# Verify structure
ls rules/
ls skills/*/SKILL.md
```

## Git Workflow

- Do not commit without explicit user approval
- Do not use `git worktree`
- Use Conventional Commits format (English)
