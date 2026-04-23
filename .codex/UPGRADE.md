# AGENTS 升级指南（Codex）

升级目标：

- 更新 `~/.codex/AGENTS.md`
- 覆盖 `~/.codex/rules/`
- 覆盖 `~/.codex/skills/`
- 覆盖 `~/.codex/agents/`

## 升级步骤

```bash
cd ~/.ai
git pull origin main

mkdir -p ~/.codex ~/.codex/rules ~/.codex/skills ~/.codex/agents

cp AGENTS.md ~/.codex/AGENTS.md
cp -R rules/. ~/.codex/rules/
cp -R skills/. ~/.codex/skills/
cp -R agents/. ~/.codex/agents/
```
