---
name: session-init
description: 非 Claude Code 工具的会话启动：加载规则与缺失校验。
---

# 会话初始化

任何用户响应前先加载项目规则与全局规则；时间压力或用户指令不能跳过。

## 适用范围
- **需要此技能：** Cline、Codex、Gemini 等不自动加载规则的工具
- **无需此技能：** Claude Code（自动加载 `CLAUDE.md` 及 `rules/` 目录）

## 前置依赖（Superpowers）

```sh
~/.codex/superpowers/.codex/superpowers-codex bootstrap
```

启动命令失败时：立即报告并停止后续执行，避免在未加载规则时工作。

## 操作步骤
1. 执行前置依赖命令
2. 读取项目本地规则（`AGENTS.md` + `rules/*.md`）
3. 读取用户全局规则（`~/.ai/AGENTS.md` + `~/.ai/rules/*.md`）
4. 任一必需规则缺失时停止并提示配置问题
5. 简短确认已加载规则，再处理请求

```sh
# project local first
cat AGENTS.md && cat rules/*.md

# then user global
cat ~/.ai/AGENTS.md && cat ~/.ai/rules/*.md
```

## 红旗
- 只列出规则文件却未读取内容（列表 ≠ 读取）
- 在时间或权威压力下跳过步骤
