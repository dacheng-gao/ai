# Codex 升级指南

本指南帮助您升级 AI Agent Rules 和 Skills。

## 升级前准备

### 备份现有配置

```sh
cp -r ~/.codex/rules ~/.codex/rules.backup.$(date +%Y%m%d)
cp -r ~/.codex/skills ~/.codex/skills.backup.$(date +%Y%m%d)
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

### 同步到 Codex

```sh
# 同步 AGENTS.md 并追加 Codex 专用配置
cp ~/.ai/AGENTS.md ~/.codex/AGENTS.md
cat >> ~/.codex/AGENTS.md <<'EOF'

---

## Superpowers System

<EXTREMELY_IMPORTANT>
You have superpowers. Superpowers teach you new skills and capabilities. RIGHT NOW run: `~/.codex/superpowers/.codex/superpowers-codex bootstrap` and follow the instructions it returns.
</EXTREMELY_IMPORTANT>
EOF

# 同步规则
cp -r ~/.ai/rules/* ~/.codex/rules/

# 同步技能（使用 rsync 保留现有技能）
rsync -av --delete ~/.ai/skills/ ~/.codex/skills/
```

## 处理冲突

### 自定义规则

如果您自定义了规则文件，合并时可能产生冲突：

```sh
cd ~/.codex/rules
# 比对差异
diff ~/.ai/rules/roles.md roles.md
```

手动合并变更，保留您的自定义内容。

### 自定义技能

如果您创建了自定义技能，建议将其放在单独目录：

```sh
mkdir -p ~/.codex/skills.custom
# 将自定义技能移到此目录
```

这样不会被 rsync 的 `--delete` 选项影响。

## 验证升级

### 检查文件完整性

```sh
# 规则文件
ls -l ~/.codex/rules/

# 技能文件
ls -l ~/.codex/skills/*/
```

### 测试功能

启动 Codex 并测试：

```sh
codex "列出所有可用的技能"
codex "检查规则是否正确加载"
```

## 回滚

如果升级后出现问题，可以回滚：

```sh
# 恢复备份
cp -r ~/.codex/rules.backup.*/ ~/.codex/rules/
cp -r ~/.codex/skills.backup.*/ ~/.codex/skills/

# 或回滚 git 仓库
cd ~/.ai
git log --oneline
git checkout <previous-commit-hash>
```

## 获取帮助

遇到问题？查看：
- [GitHub Issues](https://github.com/dacheng-gao/ai/issues)
- [Superpowers 文档](https://github.com/obra/superpowers)
