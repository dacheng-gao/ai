# Claude Code Upgrade

## Steps

```sh
# 1. Pull latest
cd ~/.ai && git pull origin main

# 2. Sync files
cp ~/.ai/AGENTS.md ~/.claude/CLAUDE.md
cp ~/.ai/rules/*.md ~/.claude/rules/
rsync -av --delete ~/.ai/skills/ ~/.claude/skills/
rsync -av --delete ~/.ai/agents/ ~/.claude/agents/
cp ~/.ai/hooks/*.sh ~/.claude/hooks/ && chmod +x ~/.claude/hooks/*.sh

# 3. Sync settings (manually merge if customized)
# If no local customizations:
cp ~/.ai/.claude/settings.template.json ~/.claude/settings.json
# If customized: diff and merge permissions/hooks sections manually
```

## Verify

Run in Claude Code:

```
列出所有可用的技能
```
