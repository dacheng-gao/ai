# OpenCode 安装指南

本指南帮助您将 AI Agent Rules 和 Skills 集成到 OpenCode 中。

## 前置条件

- 已安装 [Superpowers](https://github.com/obra/superpowers)
- 已安装 OpenCode

## 安装步骤

### 1. 克隆本仓库

```sh
git clone https://github.com/dacheng-gao/ai ~/.ai
cd ~/.ai
```

### 2. 创建 OpenCode 配置目录

```sh
mkdir -p ~/.config/opencode/rules
mkdir -p ~/.config/opencode/skills
```

### 3. 复制入口文件

```sh
cp ~/.ai/AGENTS.md ~/.config/opencode/AGENTS.md
```

### 4. 复制规则文件

```sh
cp ~/.ai/rules/* ~/.config/opencode/rules/
```

### 5. 复制技能文件

```sh
cp -r ~/.ai/skills/* ~/.config/opencode/skills/
```

## 验证安装

启动 OpenCode，并运行：

```
列出所有可用的技能
```

OpenCode 应该能够识别并使用 `~/.ai` 中的规则和技能。

## 常见问题

### 技能未识别

确保技能文件位于正确的目录：
```sh
ls -la ~/.config/opencode/skills/
```

每个技能目录应包含 `SKILL.md` 文件。

### 规则未加载

检查 `~/.config/opencode/rules/` 目录：
```sh
ls -la ~/.config/opencode/rules/
```

### AGENTS.md 未被读取

检查 `~/.config/opencode/rules/` 目录：

```sh
ls -la ~/.config/opencode/rules/
```

### 需要更新

参考 [UPGRADE.md](UPGRADE.md) 进行更新。

## 下一步

- 查看 [Superpowers 文档](https://github.com/obra/superpowers) 了解如何使用技能
- 阅读 `~/.ai/skills/` 下的各个 `SKILL.md` 文件了解具体技能用法
