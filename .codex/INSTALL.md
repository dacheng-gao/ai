# AGENTS 安装指南（Codex）

安装目标：

- `~/.codex/AGENTS.md`
- `~/.codex/rules/`
- `~/.codex/skills/`
- `~/.codex/agents/`

## 安装步骤

```bash
cd ~

if [ -d ".ai" ]; then
    cd .ai && git pull origin main
else
    git clone https://github.com/dacheng-gao/ai ~/.ai
    cd ~/.ai
fi

mkdir -p ~/.codex ~/.codex/rules ~/.codex/skills ~/.codex/agents

cp AGENTS.md ~/.codex/AGENTS.md
cp -R rules/. ~/.codex/rules/
cp -R skills/. ~/.codex/skills/
cp -R agents/. ~/.codex/agents/
```

## 升级

运行 `.codex/UPGRADE.md` 中的命令。
