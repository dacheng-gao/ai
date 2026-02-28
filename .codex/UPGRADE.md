# AGENTS 系统升级指南（Codex）

## 快速升级

```bash
# 需预装 rsync 与 jq
cd ~/.ai

# 1. 拉取最新代码
git pull origin main

# 2. 确保目录存在
mkdir -p ~/.codex/rules ~/.codex/skills ~/.codex/agents ~/.codex/hooks

# 3. 同步核心配置文件
cp CLAUDE.md ~/.codex/CLAUDE.md
cp AGENTS.md ~/.codex/AGENTS.md

# 4. 同步规则（删除上游已移除文件，避免残留旧规则）
rsync -av --delete rules/ ~/.codex/rules/

# 5. 同步技能（使用 rsync 保持目录结构）
rsync -av --delete skills/ ~/.codex/skills/

# 6. 同步 Agent 定义
rsync -av --delete agents/ ~/.codex/agents/

# 7. 同步 Hooks
rsync -av --delete hooks/ ~/.codex/hooks/
chmod +x ~/.codex/hooks/*.sh 2>/dev/null || true

# 8. 验证
echo "Skills: $(ls ~/.codex/skills/*/SKILL.md 2>/dev/null | wc -l | tr -d ' ')"
```

## 完全重装

如果升级过程中遇到问题，可以执行完全重装：

```bash
# 1. 备份配置
cp ~/.codex/config.toml ~/.codex/config.toml.backup 2>/dev/null || true

# 2. 删除旧文件
rm -f ~/.codex/CLAUDE.md ~/.codex/AGENTS.md
rm -rf ~/.codex/rules ~/.codex/skills ~/.codex/agents ~/.codex/hooks

# 3. 执行全新安装
# 按照 .codex/INSTALL.md 中的步骤执行
```

## 回滚

如果升级后出现问题，可以使用 git 回滚：

```bash
cd ~/.ai
git checkout HEAD~1  # 或指定 commit
# 然后重新执行同步步骤
```
