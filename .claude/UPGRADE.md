# AGENTS 升级指南（Claude Code）

升级目标：

- 更新 `~/.claude/CLAUDE.md`
- 更新 `~/.claude/AGENTS.md`
- 覆盖 `~/.claude/rules/`
- 覆盖 `~/.claude/skills/`
- 覆盖 `~/.claude/agents/`

## 升级步骤

```bash
cd ~/.ai
git pull origin main

mkdir -p ~/.claude ~/.claude/rules ~/.claude/skills ~/.claude/agents

cp CLAUDE.md ~/.claude/CLAUDE.md
cp AGENTS.md ~/.claude/AGENTS.md
cp -R rules/. ~/.claude/rules/
cp -R skills/. ~/.claude/skills/
cp -R agents/. ~/.claude/agents/
```
