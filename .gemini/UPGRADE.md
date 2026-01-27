# Antigravity 升级指南

本指南帮助您升级 AI Agent Rules 和 Skills。

## 升级前准备

### 备份现有配置

```sh
cp -r ~/.gemini/antigravity/global_skills ~/.gemini/antigravity/global_skills.backup.$(date +%Y%m%d)
cp ~/.gemini/GEMINI.md ~/.gemini/GEMINI.md.backup.$(date +%Y%m%d)
```

### 检查当前版本

```sh
cd ~/.ai
git log -1 --format="%H %s"
```

## 升级步骤

### 方法 1: 使用 git pull（推荐）

```sh
cd ~/.ai
git pull origin main
```

### 方法 2: 手动同步

```sh
cd ~/.ai
git fetch origin
git diff origin/main --stat
# 检查变更后
git merge origin/main
```

### 同步到 Antigravity

```sh
# 同步 GEMINI.md 并追加 Gemini 专用配置
cp ~/.ai/AGENTS.md ~/.gemini/GEMINI.md
cat >> ~/.gemini/GEMINI.md <<'EOF'

---

## Superpowers System

<EXTREMELY_IMPORTANT>
You have superpowers. Superpowers teach you new skills and capabilities. RIGHT NOW run: `~/.codex/superpowers/.codex/superpowers-codex bootstrap` and follow the instructions it returns.
</EXTREMELY_IMPORTANT>

## Session Init

<EXTREMELY_IMPORTANT>
You MUST always invoke the `session-init` skill before responding to any user request.
</EXTREMELY_IMPORTANT>
EOF

# 同步技能（使用 rsync 保留现有技能）
rsync -av --delete ~/.ai/skills/ ~/.gemini/antigravity/global_skills/
```

## 处理冲突

### 自定义技能

如果您创建了自定义技能，建议将其放在单独目录：

```sh
mkdir -p ~/.gemini/antigravity/custom_skills
# 将自定义技能移到此目录
```

这样不会被 rsync 的 `--delete` 选项影响。

### GEMINI.md 自定义内容

如果您在 GEMINI.md 中添加了自定义内容，创建 `~/.gemini/GEMINI.custom.md`，然后在 GEMINI.md 中引用：

```md
# AI Agent Instructions

本文件提供可复用的 AI 辅助开发规则和技能。

...（默认内容）...

## 自定义配置

<include path="~/.gemini/GEMINI.custom.md">
```

## 验证升级

### 检查文件完整性

```sh
# 技能文件
ls -l ~/.gemini/antigravity/global_skills/*/

# 入口文件
cat ~/.gemini/GEMINI.md
```

### 测试功能

启动 Antigravity 并测试：

```
列出所有可用的技能
检查规则是否正确加载
```

## 回滚

如果升级后出现问题，可以回滚：

```sh
# 恢复备份
cp -r ~/.gemini/antigravity/global_skills.backup.*/ ~/.gemini/antigravity/global_skills/
cp ~/.gemini/GEMINI.md.backup.* ~/.gemini/GEMINI.md

# 或回滚 git 仓库
cd ~/.ai
git log --oneline
git checkout <previous-commit-hash>
```

## 获取帮助

遇到问题？查看：
- [GitHub Issues](https://github.com/dacheng-gao/ai/issues)
- [Superpowers 文档](https://github.com/obra/superpowers)
