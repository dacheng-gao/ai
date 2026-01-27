# Codex 安装指南

本指南帮助您将 AI Agent Rules 和 Skills 集成到 Codex 中。

## 前置条件

- 已安装 [Superpowers](https://github.com/obra/superpowers)
- 已安装 Codex

## 安装步骤

### 1. 克隆本仓库

```sh
git clone https://github.com/dacheng-gao/ai ~/.ai
cd ~/.ai
```

### 2. 创建 Codex 配置目录

```sh
mkdir -p ~/.codex/rules
mkdir -p ~/.codex/skills
```

### 3. 复制入口文件

```sh
cp ~/.ai/AGENTS.md ~/.codex/AGENTS.md
cat >> ~/.codex/AGENTS.md <<'EOF'

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
```

### 4. 复制规则文件

```sh
cp ~/.ai/rules/* ~/.codex/rules/
```

### 5. 复制技能文件

```sh
cp -r ~/.ai/skills/* ~/.codex/skills/
```

## 验证安装

启动一个新的 Codex 会话，并运行：

```sh
codex "列出所有可用的技能"
```

Codex 应该能够识别并使用 `~/.ai` 中的规则和技能。

## 常见问题

### 技能未识别

确保技能文件位于正确的目录：
```sh
ls -la ~/.codex/skills/
```

每个技能目录应包含 `SKILL.md` 文件。

### 规则未加载

检查 `~/.codex/AGENTS.md` 是否正确配置，并确认规则文件存在：
```sh
ls -la ~/.codex/rules/
```

### 需要更新

参考 [UPGRADE.md](UPGRADE.md) 进行更新。

## 下一步

- 查看 [Superpowers 文档](https://github.com/obra/superpowers) 了解如何使用技能
- 阅读 `~/.ai/skills/` 下的各个 `SKILL.md` 文件了解具体技能用法
