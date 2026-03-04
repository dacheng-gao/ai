---
name: superagents
description: 统一入口技能。所有请求先进入 superagents，再按 lane 与流程档位（Lite/Standard/Full）编排交付。
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
- 所有任务统一入口（问答、Git/GitHub、handoff、bug、feature、refactor、review、架构评审、复杂排障）
- 跨模块交互，单 Agent 易漏上下文
- 需要并行探索/实现/评审
- `using-superpowers` 后仍存在多种可行技能，需要统一路由决策

## 主入口路由（using-superpowers）

执行 `superpowers:using-superpowers` 后，不再做“是否进入 superagents”的判断；所有请求已在 superagents 内，只需判定 `lane + 流程档位`。

| 请求特征 | 入口 | 内部 lane | 默认档位 |
|---------|------|-----------|---------|
| 代码解释/概念问答 | `superagents` | `answer` | `Lite` |
| Git/GitHub 操作 | `superagents` | `git` / `github` | `Lite` |
| 跨会话续跑/交接 | `superagents` | `handoff` | `Lite` |
| 缺陷修复 | `superagents` | `fix-bug` | `Standard` |
| 功能开发 | `superagents` | `develop-feature` | `Standard` |
| 重构/性能优化 | `superagents` | `refactor` | `Standard` |
| 代码/PR/diff 评审 | `superagents` | `review-code` | `Standard` |
| 架构评审/设计审查 | `superagents` | `architecture-review` | `Standard` |
| 高风险或高复杂任务 | `superagents` | 对应 lane | `Full` |
| 无法稳定分类 | `superagents` | research → plan 兜底 | `Standard` |

路由硬规则：
1. 所有请求强制进入 `superagents`（自动触发，无需显式 `$superagents`）。
2. `answer/git/github/handoff/fix-bug/develop-feature/refactor/review-code/architecture-review` 全部作为内部 lane，不作为直接入口。
3. `Lite` 仅用于低风险小任务；命中 `rules/fast-path.md` 条件才可采用。
4. 默认使用 `Standard`；涉及安全/高风险/复杂并发时升级到 `Full`。
5. 输出中必须记录 lane 与档位决策证据（为何进入该 lane 与该档位）。

## 编排总则
1. 固定入口：先 `superpowers:using-superpowers`
2. 最小覆盖：仅选择完成任务所需的最少 Superpowers
3. 双轨执行：Superpowers（方法）+ 仓库 Agents（执行）同时生效
4. 证据闭环：关键结论附 `file:line`、命令摘要或链接
5. 质量基线：review 与自检优化统一遵循 `rules/code-quality.md`

## 流程档位（固定三档）

| 档位 | 适用任务 | 默认路径 | 验证强度 |
|------|---------|---------|---------|
| Lite | 低风险、单点、快速请求（问答/轻 Git/轻改动） | route → execute → report | 最小验证（请求对照 + 命令/语法检查 + diff 自审） |
| Standard | 常规工程任务 | research → plan → implement → review → verify → report | 标准门禁（Typecheck/Build → Lint → Test） |
| Full | 高风险、高复杂、跨模块并行任务 | parallel-research → plan → parallel-implement → dual-review → full-verify → report | 完整门禁 + 双评审 + 风险披露 |

档位选择规则：
1. 默认 `Standard`。
2. 命中 `rules/fast-path.md` 才能降级到 `Lite`。
3. 涉及安全、鉴权、敏感数据、生产事故或跨模块复杂并发，必须升级为 `Full`。

## 三层架构

| 层级 | 作用 | 主要能力 |
|------|------|---------|
| Layer 1（路由层） | 决定先做什么 | `using-superpowers` + 任务分类 |
| Layer 2（流程层） | 决定怎么做 | debugging / tdd / planning / review / verification |
| Layer 3（执行层） | 决定谁来做 | `researcher/planner/implementer/reviewer/verifier/reporter` |

## Lane 映射（Skill × Agent × 档位）

| 请求类型 | 内部 lane | 必选 Superpowers | Agent 组合 | 默认档位 |
|---------|-----------|------------------|------------|---------|
| 代码解释/概念问答 | `answer` | `using-superpowers` | `researcher` + `reporter` | `Lite` |
| Git/GitHub 操作 | `git` / `github` | `using-superpowers` | `researcher` + `reporter` | `Lite` |
| 跨会话续跑/交接 | `handoff` | `using-superpowers` | `researcher` + `reporter` | `Lite` |
| bug | `fix-bug` | `systematic-debugging` → `test-driven-development` → `verification-before-completion` | `researcher` + `implementer` + `reviewer` + `verifier` + `reporter` | `Standard` |
| feature/refactor | `develop-feature` / `refactor` | `test-driven-development` → `verification-before-completion` | `researcher` + `planner` + `implementer` + `reviewer` + `verifier` + `reporter` | `Standard` |
| review-only | `review-code` / `architecture-review` | `requesting-code-review` / `receiving-code-review` | `reviewer` (+ `security-auditor`) + `reporter` | `Standard` |
| 需求模糊/多方案 | research + planning lane | `brainstorming`（收敛后进入 `writing-plans`） | `researcher` + `planner` | `Standard` |
| 2+ 独立子问题 | 对应多 lane | `dispatching-parallel-agents` | 2-4 个并行 worker + `reporter` | `Full` |

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
1. 路由预检（master）：执行 `superpowers:using-superpowers`，判定 `lane + 档位`，并记录证据
2. 目标转换（master）：明确目标、范围、验收、不做项；涉及业务决策/缺少关键输入时先澄清
3. Lite 快速收敛（可选）：若命中 `Lite`，执行“请求对照 → 最小修改/执行 → 最小验证 → 汇报”，然后结束
4. 并行探索（research）：`Standard/Full` 至少 1 个 `researcher`；需要外部资料时追加 1 个；输出必须含 `file:line` 或链接
5. 规划拆分（planner）：产出步骤、依赖、并行标记、负责人、验收条件；每步可独立验证
6. 实现与评审（implement/review）：按文件边界执行；`Full` 启用并行 implement + 双评审；禁止同文件并行写
7. 自检优化（master+implement）：按 `rules/code-quality.md` 第 6 节执行最小优化回路；禁止顺手扩大范围
8. 验证门禁（verifier）：`Standard/Full` 固定顺序 Typecheck/Build → Lint → Test；失败回退修复并回到第 6 步，最多 3 轮
9. 汇报交付（reporter）：输出 Done/Partial/Skipped、关键改动、验证证据、残余风险、后续建议

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
- 模板装配顺序（强制）：
  1. 模板 A（入口路由）：统一进入 `superagents` 后判定 `lane + 档位`
  2. 模板 B（工程编排）：输出 `目标/范围/不做/验收/lane_plan`
  3. 模板 C（子任务委派）：向 worker 下发统一任务单，保证证据格式一致
  4. 模板 D（用户汇报）：按 Done/Partial/Skipped + 验证证据交付
- 约束：
  1. 提示词必须保持“最小必要信息”，禁止重复同义规则
  2. 每条“完成/通过”结论必须可追溯到 `file:line` 或命令摘要
  3. 对用户输出优先中文、短句、可执行

## 退出标准

| # | 标准 | 检查方式 |
|---|------|---------|
| 1 | 请求条目已逐项对照 | Done/Partial/Skipped 清单 |
| 2 | 关键结论有证据 | 命令摘要、`file:line`、链接 |
| 3 | 质量门禁完成 | 正确性、安全、性能、可维护性、验证 |
| 4 | 残余风险透明 | 未完成项与影响已显式列出 |
