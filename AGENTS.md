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

## Suggested Roles
- Core role 1
- Core role 2 (e.g. Code Reviewer, Security Expert)

## Steps / Core Process
Explicit steps or patterns (e.g. Observe -> Reproduce -> Fix -> Verify).

## Examples
Show concrete usage.

## Excuse vs Fact (借口 vs 事实)
Common pitfalls and the disciplined response.

## Red Flags (红旗)
Absolute "must-not" or "stop-immediately" conditions.
```

## Validation

Before committing changes, ensure all rules and skills follow the patterns established in `rules/` and `skills/`.

```bash
# Verify structure
ls rules/
ls skills/*/SKILL.md
```

## Git Workflow

- Always use the `commit-message` skill to generate messages.
- Do not commit without explicit user approval.
- Follow `rules/git-workflow.md` for detailed constraints.

## Implementation Standards

For complex tasks (features, major fixes):
1. **Planning Phase**: Research, check files, and propose an Implementation Plan.
2. **Execution Phase**: Implement only after the plan is agreed upon (except for Low-Risk changes).
3. **Verification**: Always use `verification-before-completion` before finishing.
