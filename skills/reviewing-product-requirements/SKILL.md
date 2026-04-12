---
name: reviewing-product-requirements
description: Use when feature ideas, issues, stakeholder notes, or partial specs need to be reviewed and turned into a concise, testable PRD with clear scope, user stories, acceptance criteria, and explicit open decisions.
---

# Reviewing Product Requirements

## Overview

`reviewing-product-requirements` 是需求收敛与 PRD 评审 lane。它的职责是：把零散、模糊、实现导向或范围失控的输入，压缩成一份短而可执行、可测试、可继续交付的 PRD。

它不替代技术设计、实现计划或测试设计。它的目标不是“把文档写长”，而是让产品、研发、测试和交付方对范围、非目标和完成定义形成同一份约定。

## When to Use

适用于：

- 粗糙想法、issue、会议纪要、评论串、口头需求，需要收敛成正式需求
- 已有 PRD，但过长、偏实现、范围膨胀或验收不可测，需要纠偏与压缩
- 需要把“为什么做、给谁做、做到什么算完成”从实现细节中分离出来
- 需要暴露影响排期、范围或上线方式的待定业务决策

## When Not to Use

以下情况不要直接进入本 skill：

- 需求已经稳定，当前工作是技术设计、任务拆解或实现落地
- 任务重点是写测试计划与测试用例，而不是确认需求边界
- 用户要的是架构评审、代码评审、缺陷修复或功能开发
- 当前输入过于空泛，连问题、用户或目标都无法识别，必须先澄清

遇到这些情况时，优先转交：

- 方案仍需澄清与收敛：`superpowers:brainstorming`
- 功能交付：`skills/develop-feature/SKILL.md`
- 测试设计：`skills/writing-test-cases/SKILL.md`
- 架构评审：`skills/architecture-review/SKILL.md`
- 代码评审：`skills/review-code/SKILL.md`

## Hard Gates

1. 在产出 PRD 前，必须先对齐：`目标 / 范围 / 非目标 / 主要用户 / 当前输入类型 / 关键假设`。
2. 必须先定义问题，再评价方案；不得把用户提出的做法直接包装成需求本身。
3. 若存在会改变范围、优先级、上线方式或测试覆盖的关键业务决策未定，结果只能标记为 `PRD 草案`，不得伪装成完成态。
4. `用户故事` 必须写清：`谁 / 要完成什么 / 为什么`；不得退化为功能列表、按钮描述或实现动作。
5. `验收标准` 必须是可观察、可判定的结果；不得写点击路径、接口步骤或实现提示。
6. 不得把技术实现细节、架构方案、迁移脚本或测试步骤混入 PRD 主体，除非它们直接影响范围或上线决策。
7. 在没有证据或明确输入支撑的情况下，不得臆造用户、业务约束、成功指标或优先级。

## Operating Loop

1. `Align`
   - 用 3-5 行归一化输入：`目标 / 范围 / 非目标 / 主要用户 / 关键假设 / 输入类型`
   - 若输入是 issue、评论或想法草稿，先区分：`用户问题 / 提议方案 / 实现提示`
2. `Challenge`
   - 检查是否存在 `XY` 问题、范围膨胀、标题误导、把方案当需求、把 v1 和未来态混写
   - 会影响范围或上线的业务决策，必须提升为 `Open Questions`
3. `Model`
   - 先建模：`背景/问题 -> 目标 -> 非目标 -> 用户/场景 -> 用户故事 -> 范围 -> FR -> 验收标准`
   - 每个核心目标都应能追踪到 `用户故事`、`FR` 或验收标准
   - 无法验证的需求，不算完成
4. `Compress`
   - 删除背景铺垫、实现猜测、重复解释和空泛路线图
   - 默认保持短文档可决策，而不是扩成说明书
5. `Decide`
   - 输入完整且关键决策已落定：`PRD Status = 完成态 PRD`
   - 仍有关键待决问题或证据缺口：`PRD Status = PRD 草案`
6. `Report`
   - 输出 `PRD Status -> Open Questions / Assumptions -> PRD Body -> Risks -> Next`
   - 若进入完成态，并需要继续测试设计，显式交接到 `skills/writing-test-cases/SKILL.md`

## Default Output Model

默认只保留必要章节；不适用的章节直接省略。

- `PRD Status`
  - `完成态 PRD` 或 `PRD 草案`
  - 若是草案，先列 `Open Questions`
- `背景 / 问题`
- `目标`
- `非目标`
- `目标用户 / 关键场景`
- `用户故事 / 关键任务`
- `范围`
  - `In Scope`
  - `Out of Scope`
- `功能需求`
  - `FR-1`, `FR-2`, ...
- `验收标准`
- `风险 / 待定决策`

仅在确实影响决策或上线时加入：

- `关键假设 / 约束与依赖`
- `测试重点`
- `成功指标`
- `拆期`
- `发布 / 迁移说明`

## Quality Checks

至少检查这些点：

- 问题是否独立于方案存在
- `v1` 范围是否被悄悄放大
- 目标、用户、非目标和约束是否清楚
- 用户故事是否真实描述用户任务，而不是实现动作
- `Goal -> User Story -> FR -> Acceptance` 是否可追踪
- 验收标准是否可测试、可判定
- 关键假设是否只保留真正影响范围、优先级、上线或测试覆盖的项
- 待决业务问题是否被如实暴露，而不是藏进默认假设

## Load Only What You Need

按需读取以下规则或相邻 skill：

- `rules/output-style.md`
  - 需要确认 PRD 对外表达与压缩方式时读取
- `rules/deliverable-quality-gate.md`
  - 需要确认文档类交付的 `PASS / CONDITIONAL PASS / FAIL` 门槛时读取
- `skills/writing-test-cases/SKILL.md`
  - PRD 进入完成态后，需要继续产出测试计划与测试用例时读取
- `skills/develop-feature/SKILL.md`
  - 需求已稳定，准备进入实现 lane 时读取
- `skills/architecture-review/SKILL.md`
  - 需求讨论已上升到系统边界、容量、可靠性或治理约束时读取

不要把 PRD 写成技术设计文档、任务清单或测试脚本。

## Red Flags

出现以下信号时，说明需求收敛正在退化：

- 还没说清问题，就开始堆功能列表
- 需求标题、描述和实际目标不一致
- 把未来态、迁移、企业边角场景和 v1 混在一起
- 用户故事写成按钮操作、接口流程或实现动作
- 验收标准不可测试，只是模糊愿景
- 关键业务决策未定，却输出“完成态 PRD”
- 为了显得完整，加入大量不影响当前决策的章节

## Deliverable Contract

对用户的交付至少应包含：

- `PRD Status`
- `Open Questions / Assumptions`
- `目标、范围、非目标`
- `用户故事 / 功能需求 / 验收标准`
- `风险 / 待定决策`
- `Next`

若进入完成态，`Next` 默认应说明：可继续使用 `skills/writing-test-cases/SKILL.md` 产出测试计划与测试用例。

若当前路径没有更优替代方案，应明确写出：`当前路径合理，暂无更优替代建议。`

## Exit Criteria

- 已明确问题、目标、非目标、主要用户与范围
- 核心目标可追踪到 `用户故事`、`FR` 或验收标准
- 验收标准具备可测试性
- 关键假设、约束与待决业务问题已如实暴露
- 已正确区分 `完成态 PRD` 与 `PRD 草案`
- 对外表达满足仓库内 `rules/output-style.md`
