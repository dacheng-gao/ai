---
name: superagents
description: 工程任务主入口技能。先用 using-superpowers 做最佳匹配，再按需直达专项技能或进入多 Agent 编排（1 master + N workers）交付。
argument-hint: "[任务描述 | issue 链接 | 需求文档路径]"
---

# Superagents

## 当前状态

!`git branch --show-current 2>/dev/null && git log --oneline -5 2>/dev/null`
!`git status --short 2>/dev/null | head -20`

## Superpowers 能力基线
- `superpowers:using-superpowers`
- `superpowers:brainstorming`
- `superpowers:systematic-debugging`
- `superpowers:test-driven-development`
- `superpowers:writing-plans`
- `superpowers:executing-plans`
- `superpowers:subagent-driven-development`
- `superpowers:dispatching-parallel-agents`
- `superpowers:requesting-code-review`
- `superpowers:receiving-code-review`
- `superpowers:verification-before-completion`
- `superpowers:using-git-worktrees`
- `superpowers:finishing-a-development-branch`
- `superpowers:writing-skills`

校验命令：`curl -fsSL https://api.github.com/repos/obra/superpowers/contents/skills | jq -r '.[].name'`

## 适用场景
- 工程任务主入口（bug、feature、refactor、review、复杂排障）
- 跨模块交互，单 Agent 易漏上下文
- 需要并行探索/实现/评审
- `using-superpowers` 后仍存在多种可行技能，需要统一路由决策

## 主入口路由（using-superpowers）

执行 `superpowers:using-superpowers` 后，master 必须先判定 Best-match Skill，再决定“直达专项技能”或“进入 superagents lane”。

| 请求特征 | Best-match Skill | 直达专项技能条件 | 进入 superagents 条件 |
|---------|------------------|------------------|-----------------------|
| 代码解释/概念问答 | `answer` | 默认直达 | 需要同时落地代码改动 |
| 架构评审/设计审查 | `architecture-review` | 仅产出评审结论 | 评审后还要跨模块实施 |
| 代码/PR/diff 评审 | `review-code` | 纯 review-only | review 后需并行修复+验证 |
| Git/GitHub 操作 | `git` / `github` | 单一仓库操作 | 涉及跨模块改动与验证编排 |
| 缺陷修复 | `fix-bug` | 单模块、路径明确 | 跨模块/多根因/需并行定位 |
| 功能开发 | `develop-feature` | 输入清晰、实现路径单一 | 跨模块/多方案/需多角色并行 |
| 重构/性能优化 | `refactor` | 影响面可控、单线执行 | 影响广、需分 lane 并行 |
| 跨会话续跑/交接 | `handoff` | 默认直达 | 交接后仍需多角色并行实施 |
| 无法稳定分类 | `superagents` | 不适用 | 作为兜底入口进行 research→plan |

路由硬规则：
1. 用户显式指定 Skill 时优先遵从（与安全/正确性冲突除外）。
2. 若命中“直达专项技能条件”，直接应用该 Skill，不强行进入 superagents 实现 lane。
3. 若命中“进入 superagents 条件”或分类不稳定，进入 superagents 全流程编排。
4. 输出中必须记录路由决策证据（为何该 Skill 是 best-match）。

## 编排总则
1. 固定入口：先 `superpowers:using-superpowers`
2. 最小覆盖：仅选择完成任务所需的最少 Superpowers
3. 双轨执行：Superpowers（方法）+ 仓库 Agents（执行）同时生效
4. 证据闭环：关键结论附 `file:line`、命令摘要或链接
5. 质量基线：review 与自检优化统一遵循 `rules/code-quality.md`

## 三层架构

| 层级 | 作用 | 主要能力 |
|------|------|---------|
| Layer 1（路由层） | 决定先做什么 | `using-superpowers` + 任务分类 |
| Layer 2（流程层） | 决定怎么做 | debugging / tdd / planning / review / verification |
| Layer 3（执行层） | 决定谁来做 | `researcher/planner/implementer/reviewer/verifier/reporter` |

## 任务类型映射（Superpowers × Agents）

| 类型 | 必选 Superpowers | Lane 路径 | Agent 组合 |
|------|------------------|-----------|------------|
| bug | `systematic-debugging` → `test-driven-development` → `verification-before-completion` | research → plan → implement → review → verify → report | `researcher` + `implementer` + `reviewer` + `verifier` + `reporter` |
| feature/refactor | `test-driven-development` → `verification-before-completion` | research → plan → implement → review → verify → report | `researcher` + `planner` + `implementer` + `reviewer` + `verifier` + `reporter` |
| review-only | `requesting-code-review` / `receiving-code-review` | review → verify(按适用) → report | `reviewer` (+ `security-auditor`) + `reporter` |
| 需求模糊/多方案 | `brainstorming`（收敛后进入 `writing-plans`） | research → plan(含方案对比) | `researcher` + `planner` |
| 现成计划执行 | `subagent-driven-development`（同会话）或 `executing-plans`（跨会话） | implement → review → verify → report | `implementer` + `reviewer` + `verifier` + `reporter` |
| 2+ 独立子问题 | `dispatching-parallel-agents` | 多 lane 并行后汇合 | 2-4 个并行 worker + `reporter` |

## 团队拓扑（默认 1 master + N workers）

| 角色 | 职责 | 并行策略 |
|------|------|---------|
| master | 路由、编排、门禁决策、最终交付 | 唯一 |
| researcher | 收集代码/外部上下文 | 1-2 并行 |
| planner | 生成计划与依赖图 | 串行 |
| implementer | 按文件所有权实施 | 1-2 并行 |
| reviewer | 评审需求满足度与质量 | 1-2 并行 |
| verifier | typecheck/lint/test 验证 | 串行 |
| reporter | 汇总产出与证据 | 串行 |

## 工作流
1. 路由预检（master）：执行 `superpowers:using-superpowers`，按“主入口路由表”判定 best-match；命中直达条件则转入对应专项 Skill，否则进入 superagents lane
2. 目标转换（master）：明确目标、范围、验收、不做项；涉及业务决策/缺少关键输入时先澄清
3. 并行探索（research）：至少 1 个 `researcher`，需要外部资料时追加 1 个；输出必须含 `file:line` 或链接
4. 规划拆分（planner）：产出步骤、依赖、并行标记、负责人、验收条件；每步可独立验证
5. 任务分支（master）：review 类跳过 implement lane；有 2+ 独立子问题先调用 `dispatching-parallel-agents`
6. 实现执行（implement）：按文件边界拆分，禁止同文件并行写；bug 先 debugging，行为变更遵循 TDD
7. 并行评审（review）：至少 1 个 reviewer 做需求/回归审查；至少 1 个 reviewer 或 `security-auditor` 做安全/性能/可维护性审查；改动提示词文件时追加 `prompt-engineer`；输出必须区分 `阻断项` 与 `低成本优化项`
8. 自检优化（master+implement）：按 `rules/code-quality.md` 第 6 节执行最小优化回路，默认修复触及范围内低成本问题（死代码、冗余注释、局部低效实现）；禁止顺手扩大范围
9. 验证门禁（verifier）：固定顺序 Typecheck/Build → Lint → Test；失败回退修复并回到第 7 步，最多 3 轮；完成前必须满足 `verification-before-completion`
10. 汇报交付（reporter）：输出 Done/Partial/Skipped、关键改动、验证证据、残余风险、后续建议

## 会话预算与收敛
- 禁止“无限 loop”表述；默认最多 `3` 轮 `review → optimize → verify`。
- 单会话上下文接近预算上限时，优先压缩上下文（结论化摘要 + 证据索引），必要时触发 `handoff` 跨会话续跑。
- 到达轮次上限仍未收敛：停止继续打补丁，输出残余风险与下一轮执行建议。

## Review 自检检查清单
- 手术式改动：是否只改动当前目标相关代码
- Minimal：是否存在可移除的非必要抽象/依赖/配置
- Efficient：热点路径是否避免明显低效实现
- Dead code：触及范围内未使用代码是否已清理
- 注释质量：是否只保留解释“为什么”的必要注释
- Robust：边界与失败路径是否有明确处理策略

## 并发与冲突策略
- 并行 worker 建议 `2-4`，默认 `3`
- 小任务或高冲突任务：降到 `2`
- 跨模块且文件边界清晰：可升到 `4`
- 禁止同文件被多个 implementer 同时写入

## 冲突优先级与降级
优先级：`安全 > 正确性 > 用户明确要求 > CLAUDE.md 强制项 > 其他规则/技能`

| 不可用能力 | 手动降级流程 |
|-----------|--------------|
| `brainstorming` | 快速扫描代码 + 一次性关键问题澄清 + 方案确认 |
| `systematic-debugging` | 复现 → 证据收集 → 根因假设 → 最小改动验证 |
| `test-driven-development` | 先补失败用例再实现，保留红绿证据 |
| `dispatching-parallel-agents` | master 手动切分并行子任务并明确文件边界 |
| `verification-before-completion` | 手动执行 Typecheck/Build → Lint → Test 并给结果摘要 |

## 子 Agent 输入模板

```text
目标:
范围:
不做:
输入证据:
输出要求:
- status: success|partial|failed|blocked
- 结论:
- 证据: file:line / command / url
- 风险:
- 下一步:
```

## 领域提示词复用
- 模板文件：`skills/superagents/templates/universal-engineering-task-prompt.md`
- 使用步骤：
  1. 替换占位符并明确 `范围/不做`
  2. 绑定真实验证命令（Build/Typecheck/Lint/Test）
  3. 作为 planner/implementer/reviewer 的共享输入

## 退出标准

| # | 标准 | 检查方式 |
|---|------|---------|
| 1 | 请求条目已逐项对照 | Done/Partial/Skipped 清单 |
| 2 | 关键结论有证据 | 命令摘要、`file:line`、链接 |
| 3 | 质量门禁完成 | 正确性、安全、性能、可维护性、验证 |
| 4 | 残余风险透明 | 未完成项与影响已显式列出 |
