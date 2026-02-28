# AGENTS 系统安装指南（Codex）

## Prerequisites

- Codex 已安装
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
mkdir -p ~/.codex/rules ~/.codex/skills ~/.codex/agents ~/.codex/hooks

# 4. 复制核心配置文件
cp ~/.ai/CLAUDE.md ~/.codex/CLAUDE.md
cp ~/.ai/AGENTS.md ~/.codex/AGENTS.md

# 5. 同步规则（删除上游已移除文件，避免残留旧规则）
rsync -av --delete ~/.ai/rules/ ~/.codex/rules/

# 6. 复制技能（使用 rsync 保持目录结构）
rsync -av --delete ~/.ai/skills/ ~/.codex/skills/

# 7. 同步 Agent 定义
rsync -av --delete ~/.ai/agents/ ~/.codex/agents/

# 8. 同步并设置 Hooks
rsync -av --delete ~/.ai/hooks/ ~/.codex/hooks/
chmod +x ~/.codex/hooks/*.sh 2>/dev/null || true

# 9. 检查 config.toml
# Codex 使用 ~/.codex/config.toml，默认不覆盖用户现有配置
if [ ! -f ~/.codex/config.toml ]; then
    echo "未检测到 ~/.codex/config.toml，可先运行一次 codex 让其自动生成"
else
    echo "检测到现有 config.toml，已保留原配置"
fi

# 10. 验证安装
echo "验证安装..."
echo "Rules: $(ls ~/.codex/rules/*.md 2>/dev/null | wc -l | tr -d ' ') files"
echo "Skills: $(ls ~/.codex/skills/*/SKILL.md 2>/dev/null | wc -l | tr -d ' ') skills"
echo "Agents: $(ls ~/.codex/agents/*.md 2>/dev/null | wc -l | tr -d ' ') agents"
echo "Hooks: $(ls ~/.codex/hooks/*.sh 2>/dev/null | wc -l | tr -d ' ') hooks"
```

## 故障排除

### Hook 执行失败

```bash
# 检查 Hook 权限
ls -la ~/.codex/hooks/*.sh
# 应该都是 -rwxr-xr-x

# 重新设置权限
chmod +x ~/.codex/hooks/*.sh
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
cp ~/.codex/config.toml ~/.codex/config.toml.backup 2>/dev/null || true

# 删除所有文件
rm -rf ~/.codex

# 或者只删除 AGENTS 相关文件
rm -f ~/.codex/CLAUDE.md ~/.codex/AGENTS.md
rm -rf ~/.codex/rules ~/.codex/skills ~/.codex/agents ~/.codex/hooks
```

## 更新

运行 `.codex/UPGRADE.md` 中的升级命令。
