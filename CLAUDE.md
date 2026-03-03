# CLAUDE.md

## 最小路由原则

1. 先路由再执行：先完成 `using-superpowers`，再进入具体 Skill
2. 最小技能集合：仅选覆盖当前请求所需的最少 Skill
3. 先专后总：轻量单一任务优先专用 Skill（如 `answer`、`git`、`github`、`handoff`）；工程任务默认进入 `superagents`；无匹配由 `superagents` 兜底路由
4. 证据闭环：任何“已完成/已验证”结论都需附命令与结果摘要

---

## 仓库说明

本仓库是 AI Agent 框架源仓库。`~/.claude/` 下的 `CLAUDE.md`、`rules/`、`skills/`、`agents/` 是从本项目安装的副本；内容一致属正常。

工作流：
1. 在本项目修改源文件
2. 运行 `.claude/INSTALL.md` 或 `UPGRADE.md` 安装到 `~/.claude/`

---

@AGENTS.md
