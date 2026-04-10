# AGENTS 系统安装指南（Codex）

## Prerequisites

- Codex 已安装
- Git 已安装
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
mkdir -p ~/.codex/rules ~/.codex/skills ~/.codex/agents

# 4. 复制核心配置文件
cp ~/.ai/CLAUDE.md ~/.codex/CLAUDE.md
cp ~/.ai/AGENTS.md ~/.codex/AGENTS.md

# 5. 同步规则（删除上游已移除文件，避免残留旧规则）
rsync -av --delete ~/.ai/rules/ ~/.codex/rules/

# 6. 同步技能（保留 superpowers 软链接，避免被 --delete 清理）
rsync -av --delete --exclude 'superpowers' ~/.ai/skills/ ~/.codex/skills/

# 6.1 确保 superpowers 软链接存在
if [ -d ~/.codex/superpowers/skills ]; then
    rm -rf ~/.codex/skills/superpowers
    ln -sfn ~/.codex/superpowers/skills ~/.codex/skills/superpowers
else
    if [ -e ~/.codex/skills/superpowers ] || [ -L ~/.codex/skills/superpowers ]; then
        rm -rf ~/.codex/skills/superpowers
        echo "警告: 未检测到 ~/.codex/superpowers/skills，已移除陈旧的 ~/.codex/skills/superpowers"
    else
        echo "警告: 未检测到 ~/.codex/superpowers/skills，请先安装 superpowers 插件"
    fi
fi

# 7. 同步 Agent 定义
rsync -av --delete ~/.ai/agents/ ~/.codex/agents/

# 8. 检查 config.toml
# Codex 使用 ~/.codex/config.toml，默认不覆盖用户现有配置
if [ ! -f ~/.codex/config.toml ]; then
    echo "未检测到 ~/.codex/config.toml，可先运行一次 codex 让其自动生成"
else
    echo "检测到现有 config.toml，已保留原配置"
fi

# 9. 验证安装
echo "验证安装..."
echo "Rules: $(ls ~/.codex/rules/*.md 2>/dev/null | wc -l | tr -d ' ') files"
echo "Skills: $(ls ~/.codex/skills/*/SKILL.md 2>/dev/null | wc -l | tr -d ' ') skills"
echo "Agents: $(ls ~/.codex/agents/*.md 2>/dev/null | wc -l | tr -d ' ') agents"
if [ -L ~/.codex/skills/superpowers ]; then
    SUPERPOWERS_TARGET="$(readlink ~/.codex/skills/superpowers)"
    if [ -d "$SUPERPOWERS_TARGET" ]; then
        echo "Superpowers Link: ok -> $SUPERPOWERS_TARGET"
    else
        echo "Superpowers Link: broken -> $SUPERPOWERS_TARGET"
    fi
else
    echo "Superpowers Link: missing"
fi
```

## 故障排除

### superpowers 软链接丢失

```bash
# 重新同步 skills（保护 superpowers）
rsync -av --delete --exclude 'superpowers' ~/.ai/skills/ ~/.codex/skills/

# 重建软链接
ln -sfn ~/.codex/superpowers/skills ~/.codex/skills/superpowers

# 验证（同时校验链接目标是否有效）
if [ -L ~/.codex/skills/superpowers ] && [ -d "$(readlink ~/.codex/skills/superpowers)" ]; then
    echo "ok: $(readlink ~/.codex/skills/superpowers)"
else
    echo "broken or missing"
fi
```

### rsync 未找到

```bash
# macOS
brew install rsync

# Linux
sudo apt-get install rsync
```

## 卸载

```bash
# 备份当前配置
cp ~/.codex/config.toml ~/.codex/config.toml.backup 2>/dev/null || true

# 删除所有文件
rm -rf ~/.codex

# 或者只删除 AGENTS 相关文件
rm -f ~/.codex/CLAUDE.md ~/.codex/AGENTS.md
rm -rf ~/.codex/rules ~/.codex/skills ~/.codex/agents
```

## 更新

运行 `.codex/UPGRADE.md` 中的升级命令。
