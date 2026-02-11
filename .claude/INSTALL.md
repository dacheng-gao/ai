# Claude Code Install

## Prerequisites

- [Superpowers](https://github.com/obra/superpowers) installed
- Claude Code installed

## Steps

```sh
# 1. Clone repo
git clone https://github.com/dacheng-gao/ai ~/.ai

# 2. Create directories
mkdir -p ~/.claude/rules ~/.claude/skills

# 3. Copy entry file
cp ~/.ai/AGENTS.md ~/.claude/CLAUDE.md

# 4. Copy rules and skills
cp ~/.ai/rules/* ~/.claude/rules/
cp -r ~/.ai/skills/* ~/.claude/skills/
```

## Verify

Run in Claude Code:

```
列出所有可用的技能
```
