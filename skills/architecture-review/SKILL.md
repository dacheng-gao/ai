---
name: architecture-review
description: Use when evaluating system architecture, platform design, or high-level technical structure to identify production risks, evidence gaps, and prioritized remediation without directly redesigning or implementing the system.
---

# 架构评审

## Overview

`architecture-review` 是系统级风险评审 lane。它的职责是：围绕目标、约束和证据，识别架构层阻断风险、重要缺口与优先修复项，并把结论绑定到可追溯依据。

它不是直接做重构、重设计或实现的 lane。除非用户明确要求方案设计，否则它默认产出的是评审结论，而不是替代架构演进本身。

## When to Use

适用于：

- 评估系统架构、平台边界、服务拓扑、关键数据流或高层技术设计
- 对可靠性、扩展性、安全性、可观测性、部署恢复、成本效率做生产级风险检查
- 在上线前、方案评审前、事故后或演进节点上做系统级审查
- 需要把架构风险、证据缺口和修复优先级明确化

## When Not to Use

以下情况不要直接进入本 skill：

- 用户要的是具体实现、重构落地或缺陷修复
- 任务只是解释某段代码、回答概念问题或做局部代码评审
- 需求本身还没收敛，当前更需要 PRD、方案澄清或 feature 设计
- 讨论范围仍停留在单模块内部实现，没有明显系统级边界或非功能风险

遇到这些情况时，优先转交：

- 功能交付：`skills/develop-feature/SKILL.md`
- 缺陷修复：`skills/fix-bug/SKILL.md`
- 结构调整：`skills/refactor/SKILL.md`
- 代码评审：`skills/review-code/SKILL.md`
- 需求收敛：`skills/reviewing-product-requirements/SKILL.md`
- 方案仍需先澄清与收敛：`superpowers:brainstorming`

## Hard Gates

1. 在给出正式评审结论前，必须先对齐：`评审对象 / 范围 / 目标 / 非目标 / 约束 / 当前证据`。
2. 输入缺失时，不得假装“完整评审已完成”；必须显式列出缺口，并说明哪些结论因证据不足而降级。
3. 架构评审默认至少启用显式多角色筛查，最少覆盖：`Architect / Software Engineer / QA / Operations/SRE`；涉及安全、成本、合规或 Prompt/Agent 行为时必须追加对应视角。
4. 不得把无证据的偏好、经验印象或供应商口号包装成架构结论。
5. 不得把 `architecture-review` 退化成直接重设计、代写实现方案或顺手改系统。
6. 若存在真实方案权衡、需求边界不清或明显 `XY` 风险，必须先回到 `superpowers:brainstorming`。
7. 在没有新鲜证据前，不得声称“架构没问题”“可上线”“production-ready”。

## Operating Loop

1. `Align`
   - 用最短形式回显：`对象 / 范围 / 目标 / 非目标 / 约束 / 证据`
   - 至少锁定：业务目标、关键用户路径、非功能要求、主要边界和主要风险关注点
2. `Assess Input Quality`
   - 检查是否具备最小输入：目标/SLO、流量与规模假设、拓扑与数据流、关键依赖、故障模式、部署与恢复约束
   - 缺失项一次性列出；若用户无法补充，写明假设并降级结论强度
3. `Gather Evidence`
   - 按最小必要原则收集文档、代码触点、指标、日志、事故记录、部署方式、依赖清单
   - 优先保证每条重要结论都能回链到文件、图、指标、日志或明确假设
4. `Review`
   - 默认至少检查：`边界与耦合 / 数据一致性 / 容量与扩展 / 可靠性与恢复 / 安全与访问控制 / 可观测性 / 部署与回滚 / 成本与效率`
   - 按需追加：`合规 / Prompt-Agent Behavior / 数据治理 / 支持与可启用性`
5. `Decide`
   - 先产出 findings，再产出双轨结论：
   - `Review Action`: `Accept | Concern | Rework`
   - `Quality Result`: `PASS | CONDITIONAL PASS | FAIL`
   - 只有在证据和结论一致时才允许 `Accept + PASS`
6. `Report`
   - 输出 `Findings -> Assumptions / Evidence Gaps -> Review Action -> Quality Result -> Priority Fixes -> Risks -> Done / Partial / Skipped`
   - 若无阻断问题，也必须说明证据边界与残余风险

## Severity Model

- `Critical`
  - 会阻断上线、扩展、恢复、合规或可信交付
  - 典型包括：单点故障、恢复路径缺失、权限边界错误、关键一致性漏洞、关键证据缺失却要放行
- `Important`
  - 非立即阻断，但应在当前轮处理或由用户显式接受风险
  - 典型包括：容量余量不清、观测缺口、回滚策略不足、成本失控风险、过度耦合
- `Suggestion`
  - 非阻断优化项，只有在没有更高优先级问题或用户明确要求时再给少量代表项

每条 finding 至少应包含：

- `Domain`
- `Severity`
- `Issue`
- `Why it matters`
- `Evidence`
- `Recommended action`

## Load Only What You Need

按需读取以下规则或相邻 skill：

- `rules/roles.md`
  - 需要确定显式多角色集合、升级条件或冲突裁决时读取
- `rules/deliverable-quality-gate.md`
  - 需要确认 `PASS / CONDITIONAL PASS / FAIL` 判定与证据门槛时读取
- `rules/output-style.md`
  - 需要确认对外输出骨架与表达边界时读取
- `skills/review-code/SKILL.md`
  - 评审对象其实是局部代码改动而不是系统架构时读取
- `skills/reviewing-product-requirements/SKILL.md`
  - 怀疑所谓“架构问题”其实是需求边界未定义时读取

不要把 provider-specific 框架清单整段抄进评审；只保留对当前系统有判别力的风险视角。

## Red Flags

出现以下信号时，说明架构评审正在退化：

- 还没锁定对象、范围和约束，就开始下结论
- 输入明显不完整，却输出“全面评审已完成”
- 用个人经验或框架口号替代证据
- 把评审变成大范围重设计或产品路线讨论
- 只有风险等级，没有影响、证据和可执行修复
- 明明存在跨角色冲突，却不给裁决与取舍说明
- 因为没有立即看到问题，就写“架构没问题”

## Deliverable Contract

对用户的交付至少应包含：

- `Findings`
- `Assumptions / Evidence Gaps`
- `Review Action`
- `Quality Result`
- `Priority Fixes`
- `Risks`
- `Done / Partial / Skipped`

若未发现阻断问题，必须明确写出：`未发现阻断问题`，并补充证据边界与残余风险。

若当前路径没有更优替代方案，应明确写出：`当前路径合理，暂无更优替代建议。`

## Exit Criteria

- 已明确评审对象、范围、目标、非目标、约束与证据边界
- findings 具备风险等级、影响、证据和可执行修复建议
- 多角色视角已按风险启用，且冲突有裁决
- 结论与证据一致，没有虚假确定性
- 对外汇报满足仓库内 `rules/output-style.md` 与 `rules/deliverable-quality-gate.md`
