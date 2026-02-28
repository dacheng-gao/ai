# AGENTS 系统升级指南

## 快速升级

```bash
# 需预装 rsync 与 jq
cd ~/.ai

# 1. 拉取最新代码
git pull origin main

# 2. 同步核心配置文件
cp CLAUDE.md ~/.claude/CLAUDE.md
cp AGENTS.md ~/.claude/AGENTS.md

# 3. 同步规则（删除上游已移除文件，避免残留旧规则）
rsync -av --delete rules/ ~/.claude/rules/

# 4. 同步技能（使用 rsync 保持目录结构）
rsync -av --delete skills/ ~/.claude/skills/

# 5. 同步 Agent 定义
rsync -av --delete agents/ ~/.claude/agents/

# 6. 同步 Hooks
rsync -av --delete hooks/ ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# 7. 验证
echo "Skills: $(ls ~/.claude/skills/*/SKILL.md 2>/dev/null | wc -l | tr -d ' ')"
```

## 完全重装

如果升级过程中遇到问题，可以执行完全重装：

```bash
# 1. 备份配置
cp ~/.claude/settings.json ~/.claude/settings.json.backup

# 2. 删除旧文件
rm -f ~/.claude/CLAUDE.md ~/.claude/AGENTS.md
rm -rf ~/.claude/rules ~/.claude/skills ~/.claude/agents ~/.claude/hooks

# 3. 执行全新安装
# 按照 INSTALL.md 中的步骤执行
```

## 回滚

如果升级后出现问题，可以使用 git 回滚：

```bash
cd ~/.ai
git checkout HEAD~1  # 或指定 commit
# 然后重新执行同步步骤
```
