# CLAUDE.md

## 强制技能调用

- 每次响应用户前，必须先调用 `superpowers:using-superpowers`
- 路径：`用户消息 → using-superpowers → 选择适用技能 → 执行任务`
- 调用失败或技能不可用：告知用户并停止当前任务
- 与快速路径关系：快速路径仅跳过技能专属 Superpowers（如 brainstorming、tdd），不跳过 `using-superpowers`

## 最小路由原则

1. 先路由再执行：先完成 `using-superpowers`，再进入具体 Skill
2. 最小技能集合：仅选覆盖当前请求所需的最少 Skill
3. 先专后通：优先专用 Skill（如 `review-code`、`fix-bug`），无匹配再用 `loop-until-done`
4. 证据闭环：任何“已完成/已验证”结论都需附命令与结果摘要

---

## 仓库说明

本仓库是 AI Agent 框架源仓库。`~/.claude/` 下的 `CLAUDE.md`、`rules/`、`skills/`、`agents/` 是从本项目安装的副本；内容一致属正常。

工作流：
1. 在本项目修改源文件
2. 运行 `.claude/INSTALL.md` 或 `UPGRADE.md` 安装到 `~/.claude/`

---

@AGENTS.md
