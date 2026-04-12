---
name: superagents
description: 统一路由仓库级请求到合适 lane 与交付深度。用于处理任何仓库内任务，尤其是在需要在 answer/git/github/bug/feature/refactor/review/architecture 之间选择路径、判断是否触发 brainstorming，或协调多 Agent 与多技能执行时。
---

# Superagents

## Overview

`superagents` 是仓库内任务的统一编排入口。它负责三件事：先判定任务应该进入哪个 `lane`，再判定交付深度 `Lite / Standard / Full`，最后只装配完成当前任务所需的最小 Skill + Agent 组合。

它不替代 `answer / git / github / fix-bug / develop-feature / refactor / review-code / architecture-review`；这些都只是内部 lane。

## When to Use

以下情况应进入 `superagents`：
- 任何仓库内问答、实现、评审、Git/GitHub、handoff、架构或排障任务
- 需要在多个 lane 之间做路由判断
- 需要决定是否触发 `brainstorming`
- 需要决定是否启用并行 agent、降级流程或更强验证
- 任务触及 `rules/*.md`、`AGENTS.md`、`CLAUDE.md`、`skills/*/SKILL.md`、Prompt 或 Agent 行为约束

以下情况不要把它当成“额外一层”重复调用：
- 已经处在 `superagents` 内部，只需继续当前 lane
- 只是加载参考文件，不需要重新做入口路由

## Hard Gates

1. 先执行 `superpowers:using-superpowers`，再做任何路由或实现动作。
2. 所有仓库任务统一进入 `superagents`；其他仓库技能只作为内部 lane，不作为外部直达入口。
3. 在实现、修改文件、运行高影响命令前，必须先完成开场对齐：`目标 / 范围 / 不做 / 关键假设 / 验收`。
4. 若存在目标模糊、疑似 `XY`、真实方案权衡、跨模块边界不清，必须切换到 `superpowers:brainstorming`；进入后按“一次一问”推进。
5. 必须记录 `lane + depth + evidence + next`，避免黑盒式路由。
6. 只装配最小必要 Skill 集合；不要把所有 superpowers 一次性压入上下文。
7. 触及规则、Prompt、Skill、Agent 行为时，至少升级到 `Standard`，并显式纳入 `Prompt / Agent Behavior` 视角。
8. 未拿到验证证据前，不得使用“已完成”“已通过”“production-ready”等成功表述。

## Operating Loop

1. `Route`
   - 根据用户目标、风险与上下文选择 `lane`
   - 根据风险、范围、并发与验证成本选择 `depth`
2. `Align`
   - 对用户回显 `目标 / 范围 / 不做 / 关键假设 / 验收`
   - 只有在关键输入缺失、业务决策缺失或真实 trade-off 存在时才停下提问
3. `Compose`
   - 选择最小必要 Skills、角色和验证门禁
   - 需要具体矩阵时再读取参考文件
4. `Execute`
   - `Lite`: route -> execute -> report
   - `Standard`: research -> plan -> implement -> review -> verify -> report
   - `Full`: parallel-research -> plan -> parallel-implement -> dual-review -> full-verify -> report
5. `Verify`
   - 所有“完成”结论都要绑定命令摘要、`file:line` 或链接
6. `Report`
   - 默认按 `直接执行 / 深度交互` 对用户交付

## Quick Routing Rules

| Situation | Lane | Default Depth |
|-----------|------|---------------|
| 代码解释、概念问答、轻 Git/GitHub、handoff | `answer` / `git` / `github` / `handoff` | `Lite` |
| bug、回归、错误输出、失败路径 | `fix-bug` | `Standard` |
| feature、集成、行为变更、refactor | `develop-feature` / `refactor` | `Standard` |
| 代码审查、PR 审查、架构评审 | `review-code` / `architecture-review` | `Standard` |
| 难以稳定分类、存在多方案、边界不清 | research -> planning | `Standard` |
| 安全、高风险、跨模块复杂并发、规则或 Prompt 行为改动 | 对应 lane | `Full` 候选，至少 `Standard` |

`Lite` 只在命中 `rules/fast-path.md` 且风险足够低时采用。默认 `Standard`。

## Load Only What You Need

按需读取参考文件，避免把长说明一次性塞进上下文：

- `references/routing-matrix.md`
  - 需要详细 lane/depth 选择矩阵、升级条件、降级条件时读取
- `references/orchestration-playbook.md`
  - 需要完整工作流、角色拓扑、并发边界、冲突裁决、降级流程时读取
- `templates/universal-engineering-task-prompt.md`
  - 需要生成路由、开场对齐、计划、委派或汇报提示词时读取
- `references/verification-evals.md`
  - 在声称可交付前，或在修改 `rules / skills / prompts / agent behavior` 时读取

## Red Flags

出现以下信号时，说明路由正在退化：

- 还没做开场对齐就直接开始写代码或改文档
- 因为“看起来更稳”而默认把所有任务升到 `Full`
- 把 `superagents` 写成重复 `AGENTS.md`、`rules/*` 的总汇编
- 让多个 implementer 并行改同一个文件
- 在没有证据时声称“已经验证”
- 因为任务简单而跳过 `lane / depth` 判断
- 触及规则或 Prompt 行为却仍按 `Lite` 处理

## Deliverable Contract

对用户的最终输出至少应包含：
- 请求对照：`Done / Partial / Skipped`
- 关键改动或决策
- 验证证据摘要
- 残余风险或限制

若没有有效挑战点，`深度交互` 必须明确写出“当前路径合理，暂无更优替代建议”。

## Exit Criteria

- 路由理由可追溯
- 所选 Skill / Agent 组合是最小覆盖
- 验证强度与 `depth` 一致
- 汇报遵循 `rules/output-style.md`
- 质量结论符合 `rules/deliverable-quality-gate.md`

详细矩阵、工作流、模板与 eval 规则放在配套参考文件中，按需加载。
