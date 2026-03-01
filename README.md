# AI Supergents

面向 Claude Code 和 Codex 的 AI 工程工作流。

核心定位：
- `superagents` 是复杂任务的默认入口
- `rules` 定义约束
- `skills` 定义执行流程

> 前置条件：先安装 [superpowers](https://github.com/obra/superpowers)。

## Superagents 的地位

- `skills/superagents` 是编排层，负责 1 master + N workers 的多 Agent 协作。
- 对 bug / feature / refactor / 复杂 review，优先走 `superagents`，再落到具体技能。
- 与仓库强制路由一致：先 `superpowers:using-superpowers`，再选择最小技能集合执行。

## Superagents 怎么用

直接在任务里显式触发：

```text
[$superagents](/Users/gdc/.codex/skills/superagents/SKILL.md) <任务描述>
```

常见场景：
- 缺陷修复：定位根因并修复回归，附验证证据
- 功能开发：实现需求并补齐测试与评审
- 复杂重构：保持外部行为不变，分阶段迁移

最小执行流：
1. 路由：`using-superpowers`
2. 选型：最小 Superpowers 组合（debugging/TDD/review/verification）
3. 执行：`research -> plan -> implement -> review -> verify -> report`
4. 门禁：`Typecheck/Build -> Lint -> Test`
5. 交付：Done/Partial/Skipped + `file:line`/命令摘要证据

复用模板：`skills/superagents/templates/universal-engineering-task-prompt.md`

## 仓库结构

- `rules/`：全局约束（质量、语言、输出、快速路径）
- `skills/`：专项工作流（`superagents`、`fix-bug`、`develop-feature`、`refactor` 等）
- `agents/`：执行角色（researcher/planner/implementer/reviewer/verifier/reporter）
- `AGENTS.md`：路由、协作与交付规范
- `CLAUDE.md`：仓库级强制路由规则

## 文档约定

`SKILL.md` 里的 `!command` 会在 skill 加载时执行，并把输出注入上下文，例如：

```text
!`git status`
```

## 安装

### Claude Code

```text
Fetch and follow instructions from https://raw.githubusercontent.com/dacheng-gao/ai/main/.claude/INSTALL.md
```

升级：

```text
Fetch and follow instructions from https://raw.githubusercontent.com/dacheng-gao/ai/main/.claude/UPGRADE.md
```

### Codex

```text
Fetch and follow instructions from https://raw.githubusercontent.com/dacheng-gao/ai/main/.codex/INSTALL.md
```

升级：

```text
Fetch and follow instructions from https://raw.githubusercontent.com/dacheng-gao/ai/main/.codex/UPGRADE.md
```

## License

[MIT](LICENSE)
