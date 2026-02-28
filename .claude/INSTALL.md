# AGENTS 系统安装指南

## Prerequisites

- Claude Code 已安装
- Git 已安装
- jq 已安装（JSON 处理）
- rsync 已安装（目录同步）

## 安装步骤

```bash
# 1. 进入安装目录
cd ~

# 2. Clone 或更新仓库
if [ -d ".ai" ]; then
    cd .ai && git pull origin main
else
    git clone https://github.com/dacheng-gao/ai ~/.ai
fi

# 3. 创建目录结构
mkdir -p ~/.claude/rules ~/.claude/skills ~/.claude/agents ~/.claude/hooks

# 4. 复制核心配置文件
cp ~/.ai/CLAUDE.md ~/.claude/CLAUDE.md
cp ~/.ai/AGENTS.md ~/.claude/AGENTS.md

# 5. 同步规则（删除上游已移除文件，避免残留旧规则）
rsync -av --delete ~/.ai/rules/ ~/.claude/rules/

# 6. 复制技能（使用 rsync 保持目录结构）
rsync -av --delete ~/.ai/skills/ ~/.claude/skills/

# 7. 同步 Agent 定义
rsync -av --delete ~/.ai/agents/ ~/.claude/agents/

# 8. 同步并设置 Hooks
rsync -av --delete ~/.ai/hooks/ ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# 9. 设置 settings.json
# 如果已存在自定义 settings，需要手动合并
if [ ! -f ~/.claude/settings.json ]; then
    cp ~/.ai/.claude/settings.template.json ~/.claude/settings.json
    echo "已创建默认 settings.json"
else
    echo "检测到现有 settings.json，请手动合并 permissions 和 hooks 配置"
fi

# 10. 验证安装
echo "验证安装..."
echo "Rules: $(ls ~/.claude/rules/*.md | wc -l) files"
echo "Skills: $(ls ~/.claude/skills/*/SKILL.md | wc -l) skills"
echo "Agents: $(ls ~/.claude/agents/*.md | wc -l) agents"
echo "Hooks: $(ls ~/.claude/hooks/*.sh | wc -l) hooks"
```

## 故障排除

### Hook 执行失败

```bash
# 检查 Hook 权限
ls -la ~/.claude/hooks/*.sh
# 应该都是 -rwxr-xr-x

# 重新设置权限
chmod +x ~/.claude/hooks/*.sh
```

### jq 未找到

```bash
# macOS
brew install jq

# Linux
sudo apt-get install jq
```

## 卸载

```bash
# 备份当前配置
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# 删除所有文件
rm -rf ~/.claude

# 或者只删除 AGENTS 相关文件
rm ~/.claude/CLAUDE.md ~/.claude/AGENTS.md
rm -rf ~/.claude/rules ~/.claude/skills ~/.claude/agents ~/.claude/hooks
```

## 更新

运行 `UPGRADE.md` 中的升级命令。
