---
name: develop-feature
description: Use when implementing repository feature work such as new capabilities, API or schema changes, integrations, user-facing behavior changes, or mixed code-and-doc deliverables after requirements are clear enough to execute.
---

# 开发功能

## Overview

`develop-feature` 是功能交付的执行 lane，不负责替代需求澄清、设计收敛或最终验证门禁。

它的职责是：在目标、范围与验收已足够明确后，以最小必要改动完成 feature 交付，并把完成结论绑定到可验证证据。

## When to Use

适用于：

- 新增能力、端点、集成、后台流程或用户可见行为
- 触及 public API、schema、workflow、权限或外部系统集成的功能开发
- 同时包含代码与文档的 feature 交付
- 已完成设计确认，或需求已清晰到可以直接进入实现

## When Not to Use

以下情况不要直接进入本 skill：

- 用户主要在问“应该做什么”，而不是“按什么实现”
- 需求仍模糊，存在真实方案权衡、边界不清或明显 `XY` 风险
- 任务本质是 bug 修复、重构、纯问答、代码评审或架构评审
- 只是零散记录想法、整理需求或编写测试用例

遇到这些情况时，优先转交：

- 设计收敛与方案选择：`superpowers:brainstorming`
- 实施计划拆解：`superpowers:writing-plans`
- 缺陷处理：`skills/fix-bug/SKILL.md`
- 结构调整：`skills/refactor/SKILL.md`

## Hard Gates

1. 在实现或高影响命令之前，必须先对齐：`目标 / 范围 / 不做 / 关键假设 / 验收`。
2. 若需求模糊、存在真实方案权衡、跨模块边界不清，必须先回到 `superpowers:brainstorming`，不得在本 skill 内绕过。
3. 若设计已批准但实施路径仍非极小改动，必须先转 `superpowers:writing-plans`，再回来执行。
4. 任何行为变更都必须纳入 `superpowers:test-driven-development` 的约束；不得先写生产实现再补验证。
5. 在没有新鲜验证证据前，不得声称“已完成”“已通过”“production-ready”。
6. 未经明确要求，不得顺手扩大范围做重构、迁移或体系化重写。

## Operating Loop

1. `Align`
   - 用最短形式回显：`目标 / 范围 / 不做 / 假设 / 验收`
   - 缺少关键输入时，先停下澄清，不靠猜测进入实现
2. `Classify`
   - 判断本次交付属于 `code / docs / mixed`
   - 判断风险属于 `small / standard / high-risk`
   - 若触及 API、schema、auth、external integration 或 user-visible behavior，默认至少 `standard`
3. `Gate`
   - 需要设计收敛：转 `superpowers:brainstorming`
   - 需要实施计划：转 `superpowers:writing-plans`
   - 进入实现前，按需调用 `superpowers:test-driven-development`
4. `Implement`
   - 先收集最小必要上下文，再做手术式改动
   - 保持与现有命名、语言和结构约定一致
   - 需要并行协作时，只在写集不重叠且当前平台策略允许时启用
5. `Verify`
   - 完成声明前，按 `superpowers:verification-before-completion` 执行验证
   - 验证强度必须匹配产物类型与风险等级
6. `Report`
   - 输出 `Done / Partial / Skipped`
   - 绑定关键改动、验证证据摘要和残余风险

## Load Only What You Need

按需读取配套参考文件：

- `references/feature-delivery-playbook.md`
  - 需要做 feature 分类、升级判断、并行边界、失败恢复时读取
- `references/verification-checklist.md`
  - 需要判断验证矩阵、`N/A` 规则、交付证据门槛时读取

不要把所有参考内容一次性压进上下文。

## Red Flags

出现以下信号时，说明流程正在退化：

- 还没对齐验收标准就直接写实现
- 把功能开发 skill 当成需求澄清或架构设计 skill
- 因为“改动很小”就跳过 TDD 或验证
- 用平台专有机制替代稳定流程约束
- 并行修改同一文件或同一责任边界
- 用“应该可以”“理论上通过”替代验证证据
- 把顺手重构、迁移或 cleanup 混进本次 feature 范围

## Deliverable Contract

对用户的交付至少应包含：

- `Done / Partial / Skipped`
- 本次 feature 的目标对应结果
- 关键改动或关键决策
- 验证证据摘要
- 残余风险、限制或后续建议

若当前路径没有更优替代方案，应明确写出：`当前路径合理，暂无更优替代建议。`

## Exit Criteria

- 已明确本次 feature 的目标、范围、非目标和验收
- 路由与升级动作可追溯，不与 `brainstorming / writing-plans / TDD / verification-before-completion` 冲突
- 改动范围保持最小，未混入无关重构
- 交付结论附带与产物类型匹配的验证证据
- 汇报满足仓库内 `rules/output-style.md` 与 `rules/deliverable-quality-gate.md`
