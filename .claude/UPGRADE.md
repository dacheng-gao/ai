# Claude Code Upgrade

## Steps

```sh
# 1. Pull latest
cd ~/.ai && git pull origin main

# 2. Sync files
cp ~/.ai/AGENTS.md ~/.claude/CLAUDE.md
cp ~/.ai/rules/* ~/.claude/rules/
rsync -av --delete ~/.ai/skills/ ~/.claude/skills/
```

## Verify

Run in Claude Code:

```
列出所有可用的技能
```
