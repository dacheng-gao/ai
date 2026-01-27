# Claude 安装指南

本指南帮助您将 AI Agent Rules 和 Skills 集成到 Claude Code 中。

## 前置条件

- 已安装 [Superpowers](https://github.com/obra/superpowers)
- 已安装 Claude Code

## 安装步骤

### 1. 克隆本仓库

```sh
git clone https://github.com/dacheng-gao/ai ~/.ai
cd ~/.ai
```

### 2. 创建 Claude 配置目录

```sh
mkdir -p ~/.claude/rules
mkdir -p ~/.claude/skills
```

### 3. 复制入口文件

```sh
cp ~/.ai/AGENTS.md ~/.claude/CLAUDE.md
```

### 4. 复制规则文件

Claude Code 会自动加载 `~/.claude/rules` 目录：

```sh
cp ~/.ai/rules/* ~/.claude/rules/
```

### 5. 复制技能文件

```sh
cp -r ~/.ai/skills/* ~/.claude/skills/
```

## 验证安装

启动 Claude Code，并运行：

```
列出所有可用的技能
```

Claude 应该能够识别并使用 `~/.ai` 中的规则和技能。

## 常见问题

### 技能未识别

确保技能文件位于正确的目录：
```sh
ls -la ~/.claude/skills/
```

每个技能目录应包含 `SKILL.md` 文件。

### 规则未自动加载

检查 `~/.claude/rules/` 目录是否存在且包含规则文件：
```sh
ls -la ~/.claude/rules/
```

### CLAUDE.md 未被读取

确保 CLAUDE.md 文件位于正确的路径：
```sh
cat ~/.claude/CLAUDE.md
```

### 需要更新

参考 [UPGRADE.md](UPGRADE.md) 进行更新。

## 下一步

- 查看 [Superpowers 文档](https://github.com/obra/superpowers) 了解如何使用技能
- 阅读 `~/.ai/skills/` 下的各个 `SKILL.md` 文件了解具体技能用法
