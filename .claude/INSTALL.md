# AGENTS 安装指南（Claude Code）

安装目标：

- `~/.claude/CLAUDE.md`
- `~/.claude/AGENTS.md`
- `~/.claude/rules/`
- `~/.claude/skills/`
- `~/.claude/agents/`

## 安装步骤

```bash
cd ~

if [ -d ".ai" ]; then
    cd .ai && git pull origin main
else
    git clone https://github.com/dacheng-gao/ai ~/.ai
    cd ~/.ai
fi

mkdir -p ~/.claude ~/.claude/rules ~/.claude/skills ~/.claude/agents

cp CLAUDE.md ~/.claude/CLAUDE.md
cp AGENTS.md ~/.claude/AGENTS.md
cp -R rules/. ~/.claude/rules/
cp -R skills/. ~/.claude/skills/
cp -R agents/. ~/.claude/agents/
```

## 升级

运行 `.claude/UPGRADE.md` 中的命令。
