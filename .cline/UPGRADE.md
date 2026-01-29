# Cline 升级指南

本指南帮助您升级 AI Agent Rules 和 Skills。

## 升级前准备

### 备份现有配置

```sh
cp -r ~/.cline/rules ~/.cline/rules.backup.$(date +%Y%m%d)
cp -r ~/.cline/skills ~/.cline/skills.backup.$(date +%Y%m%d)
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

### 同步到 Cline

```sh
# 同步 AGENTS.md
cp ~/.ai/AGENTS.md ~/.cline/CLINE.md

# 同步规则
cp -r ~/.ai/rules/* ~/.cline/rules/

# 同步技能（使用 rsync 保留现有技能）
rsync -av --delete ~/.ai/skills/ ~/.cline/skills/
```

## 处理冲突

### 自定义规则

如果您自定义了规则文件，合并时可能产生冲突：

```sh
cd ~/.cline/rules
# 比对差异
diff ~/.ai/rules/roles.md roles.md
```

手动合并变更，保留您的自定义内容。

### 自定义技能

如果您创建了自定义技能，建议将其放在单独目录：

```sh
mkdir -p ~/.cline/skills.custom
# 将自定义技能移到此目录
```

这样不会被 rsync 的 `--delete` 选项影响。

### CLINE.md 自定义内容

如果您在 CLINE.md 中添加了自定义内容，创建 `~/.cline/CLINE.custom.md`，然后在 CLINE.md 中引用：

```md
<include path="~/.cline/CLINE.custom.md">
```

## 验证升级

### 检查文件完整性

```sh
# 规则文件
ls -l ~/.cline/rules/

# 技能文件
ls -l ~/.cline/skills/*/

# 入口文件
cat ~/.cline/CLINE.md
```

### 测试功能

启动 Cline 并测试：

```
列出所有可用的技能
检查规则是否正确加载
```

## 回滚

如果升级后出现问题，可以回滚：

```sh
# 恢复备份
cp -r ~/.cline/rules.backup.*/ ~/.cline/rules/
cp -r ~/.cline/skills.backup.*/ ~/.cline/skills/

# 或回滚 git 仓库
cd ~/.ai
git log --oneline
git checkout <previous-commit-hash>
```

## 获取帮助

遇到问题？查看：
- [GitHub Issues](https://github.com/dacheng-gao/ai/issues)
- [Superpowers 文档](https://github.com/obra/superpowers)