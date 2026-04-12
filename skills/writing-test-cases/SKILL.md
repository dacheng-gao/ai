---
name: writing-test-cases
description: Use when a PRD, feature spec, or acceptance criteria already exist and need to be turned into a concise test plan and traceable test cases with clear priorities, coverage, and execution focus.
---

# Writing Test Cases

## Overview

`writing-test-cases` 是测试设计 lane。它的职责是：把 PRD、功能需求或验收标准，转成 `测试计划 + 可执行测试用例`，让 QA、研发或交付方知道应该验证什么、优先验证什么、以及如何证明完成。

它不负责重写需求，也不负责自动化脚本实现。它的重点是测试建模、覆盖追踪、优先级控制和可执行表达。

## When to Use

适用于：

- 已有 PRD、feature spec、功能需求或验收标准，需要继续产出测试内容
- 需要把 `FR / AC` 变成覆盖清晰、优先级明确的测试计划和测试用例
- 需要压缩冗长测试文档，保留最小可上线测试集
- 需要把上线阻断风险映射到 `P0 / P1 / P2`

## When Not to Use

以下情况不要直接进入本 skill：

- 需求仍模糊、关键业务决策未定，当前更需要收敛 PRD
- 任务重点是实现自动化脚本、测试框架选型或技术验证
- 用户要的是功能开发、缺陷修复、架构评审或代码评审
- 当前输入只有想法和方案，没有足够需求依据支撑测试设计

遇到这些情况时，优先转交：

- 需求收敛：`skills/reviewing-product-requirements/SKILL.md`
- 功能交付：`skills/develop-feature/SKILL.md`
- 缺陷修复：`skills/fix-bug/SKILL.md`
- 架构评审：`skills/architecture-review/SKILL.md`

## Hard Gates

1. 在写测试前，必须先对齐：`输入来源 / 测试目标 / 测试范围 / 非目标 / 当前证据 / 关键待决问题`。
2. 必须先审输入质量，再写测试；若需求未定、验收不清或存在关键待决问题，结果只能标记为 `测试草案`。
3. 不得把 PRD 或验收标准逐条机械翻译成 case；必须先做测试建模，再决定覆盖策略。
4. 每条 case 都必须能追踪到 `FR` 或 `AC`；无法追踪的 case 说明范围失控或输入不清。
5. `P0` 只覆盖上线阻断风险；不得把所有 case 都标成最高优先级。
6. 不得把自动化脚本实现、框架配置或调试动作写进测试用例主体，除非用户明确要求。
7. 在没有足够输入支撑的情况下，不得伪装成“完成态测试集”。

## Operating Loop

1. `Align`
   - 用最短形式锁定：`输入来源 / 测试目标 / 范围 / 非目标 / 关键待决问题`
   - 优先确认当前输入来自：`完成态 PRD / feature spec / AC / issue`
2. `Assess Input Quality`
   - 检查是否至少具备：目标、范围、功能需求、验收标准、约束、依赖、角色或权限信息
   - 若存在会改变测试范围的待决问题，降级为 `测试草案`
3. `Model`
   - 先识别：`主路径 / 失败态 / 边界值 / 角色权限 / 状态切换 / 回归影响 / 迁移兼容`
   - 先按 workflow 分组，再决定哪些独立成 case，哪些只需参数化或共享前置
4. `Plan`
   - 写清测试目标、范围、策略、环境前提、优先级和不测项
   - 先定义“最小可上线测试集”，再决定是否补充更广覆盖
5. `Specify`
   - 一条 case 只验证一个主行为
   - 每步默认写成：`动作 -> 预期结果`
   - 重复路径优先合并，不做数量膨胀
6. `Report`
   - 输出 `测试状态 -> 输入缺口 / 覆盖追踪 -> 测试计划 -> 详细用例 -> 风险 -> Next`
   - 若上游 PRD 仍有 `Open Questions`，明确说明只能给出 `测试草案`

## Default Output Model

默认只保留必要章节；不适用的章节直接省略。

- `测试状态`
  - `完成态测试集` 或 `测试草案`
  - 若是草案，先列 `输入缺口 / 待确认问题`
- `测试目标`
- `测试范围`
  - `In Scope`
  - `Out of Scope`
- `测试策略`
  - 主路径
  - 失败态
  - 边界值
  - 权限 / 角色
  - 回归
  - 迁移 / 兼容
- `优先级`
  - `P0`
  - `P1`
  - `P2`
- `环境与前置条件`
- `覆盖追踪`
  - `AC-1 -> TC-001, TC-002`
  - `FR-3 -> TC-006`
- `详细测试用例`

## Quality Checks

至少检查这些点：

- 输入是否足够支撑测试设计
- 核心验收标准是否都有覆盖
- 是否只写了主路径而漏掉失败态、边界或回归
- 不同角色/权限是否被错误混写
- 不同 workflow 是否被错误塞进同一条 case
- 重复步骤是否本应合并为共享前置、共享步骤或参数化变体
- 迁移、兼容、旧行为共存是否在适用时被覆盖
- 预期结果是否可观察、可判定

## Load Only What You Need

按需读取以下规则或相邻 skill：

- `rules/output-style.md`
  - 需要确认测试文档对外表达与压缩方式时读取
- `rules/deliverable-quality-gate.md`
  - 需要确认文档类交付的 `PASS / CONDITIONAL PASS / FAIL` 门槛时读取
- `skills/reviewing-product-requirements/SKILL.md`
  - 上游需求仍不清，或 PRD 中存在 `Open Questions` 时读取
- `skills/fix-bug/SKILL.md`
  - 当前测试设计主要服务于缺陷复现、根因验证或回归保护时读取
- `skills/develop-feature/SKILL.md`
  - 测试设计完成后，需要交接到实现 lane 时读取

不要把测试文档写成 PRD、自动化脚本或实现说明。

## Red Flags

出现以下信号时，说明测试设计正在退化：

- 上游需求未定，却输出“完成态测试集”
- 把所有 case 都标成 `P0`
- 只写主路径，没有失败态、边界或回归
- 不同角色或 workflow 被错误混进同一条 case
- 步骤冗长、重复，像手工操作录屏稿
- case 无法追踪到 `FR` 或 `AC`
- 为了显得完整，穷举所有组合而失去执行价值

## Deliverable Contract

对用户的交付至少应包含：

- `测试状态`
- `输入缺口 / 待确认问题`
- `测试目标、范围、优先级`
- `覆盖追踪`
- `详细测试用例` 或最小可上线测试集
- `Next`

若上游 PRD 仍有 `Open Questions`，`Next` 默认应说明：先回到 `skills/reviewing-product-requirements/SKILL.md` 补齐需求，再继续测试设计。

若当前路径没有更优替代方案，应明确写出：`当前路径合理，暂无更优替代建议。`

## Exit Criteria

- 已明确测试目标、范围、非目标与输入边界
- 已正确区分 `完成态测试集` 与 `测试草案`
- 核心验收标准已映射到覆盖追踪
- 高风险路径、失败态、边界、权限与回归影响已体现在计划或 case 中
- 用例优先级清晰，`P0` 覆盖最小上线风险
- 对外表达满足仓库内 `rules/output-style.md`
