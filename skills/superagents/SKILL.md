---
name: superagents
description: 复杂任务的多 Agent 编排。用 1 master + N workers（2-4 并行）驱动 researcher/planner/implementer/reviewer/verifier/reporter 协作交付。
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
- 跨模块交互，单 Agent 易漏上下文
- 需要并行探索/实现/评审
- 任务属于 bug、feature、refactor、复杂 review

## 编排总则
1. 固定入口：先 `superpowers:using-superpowers`
2. 最小覆盖：仅选择完成任务所需的最少 Superpowers
3. 双轨执行：Superpowers（方法）+ 仓库 Agents（执行）同时生效
4. 证据闭环：关键结论附 `file:line`、命令摘要或链接

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
1. 路由预检（master）：执行 `superpowers:using-superpowers`，识别 `bug|feature|refactor|review|ambiguous`，选择最小 Superpowers 组合
2. 目标转换（master）：明确目标、范围、验收、不做项；涉及业务决策/缺少关键输入时先澄清
3. 并行探索（research）：至少 1 个 `researcher`，需要外部资料时追加 1 个；输出必须含 `file:line` 或链接
4. 规划拆分（planner）：产出步骤、依赖、并行标记、负责人、验收条件；每步可独立验证
5. 任务分支（master）：review 类跳过 implement lane；有 2+ 独立子问题先调用 `dispatching-parallel-agents`
6. 实现执行（implement）：按文件边界拆分，禁止同文件并行写；bug 先 debugging，行为变更遵循 TDD
7. 并行评审（review）：至少 1 个 reviewer 做需求/回归审查；至少 1 个 reviewer 或 `security-auditor` 做安全/性能/可维护性审查；改动提示词文件时追加 `prompt-engineer`
8. 验证门禁（verifier）：固定顺序 Typecheck/Build → Lint → Test；失败回退修复，最多 3 轮；完成前必须满足 `verification-before-completion`
9. 汇报交付（reporter）：输出 Done/Partial/Skipped、关键改动、验证证据、残余风险、后续建议

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
