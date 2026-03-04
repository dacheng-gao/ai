# CLAUDE.md

## 最小路由原则

1. 先路由再执行：先完成 `using-superpowers`，再进入具体 Skill
2. 最小技能集合：仅选覆盖当前请求所需的最少 Skill
3. 统一入口：所有请求一律自动进入 `superagents`（无需显式 `$superagents`）
4. 分级流程：`superagents` 内部按复杂度选择 `Lite` / `Standard` / `Full`
5. 内部委派：`answer`、`git`、`github`、`handoff`、`fix-bug`、`develop-feature`、`refactor`、`review-code`、`architecture-review` 均作为 lane，不作为直接入口
6. 证据闭环：任何“已完成/已验证”结论都需附命令与结果摘要

---

## 仓库说明

本仓库是 AI Agent 框架源仓库。`~/.claude/` 下的 `CLAUDE.md`、`rules/`、`skills/`、`agents/` 是从本项目安装的副本；内容一致属正常。

工作流：
1. 在本项目修改源文件
2. 运行 `.claude/INSTALL.md` 或 `UPGRADE.md` 安装到 `~/.claude/`

---

@AGENTS.md
