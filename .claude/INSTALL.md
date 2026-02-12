# Claude Code Install

## Prerequisites

- [Superpowers](https://github.com/obra/superpowers) installed
- Claude Code installed

## Steps

```sh
# 1. Clone repo
git clone https://github.com/dacheng-gao/ai ~/.ai

# 2. Create directories
mkdir -p ~/.claude/rules ~/.claude/skills ~/.claude/agents ~/.claude/hooks

# 3. Copy entry file
cp ~/.ai/AGENTS.md ~/.claude/CLAUDE.md

# 4. Copy rules, skills, agents, hooks
cp ~/.ai/rules/*.md ~/.claude/rules/
cp -r ~/.ai/skills/* ~/.claude/skills/
cp ~/.ai/agents/*.md ~/.claude/agents/
cp ~/.ai/hooks/*.sh ~/.claude/hooks/ && chmod +x ~/.claude/hooks/*.sh

# 5. Install settings (merge into existing or use as base)
# If no existing settings.json:
cp ~/.ai/.claude/settings.template.json ~/.claude/settings.json
# If existing settings.json: manually merge permissions and hooks sections
```

## Verify

Run in Claude Code:

```
列出所有可用的技能
```
