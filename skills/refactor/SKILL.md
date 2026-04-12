---
name: refactor
description: Use when improving internal code structure without intentionally changing externally observable behavior, such as module splits, simplification, dependency cleanup, or maintainability and performance-oriented restructuring.
---

# 重构

## Overview

`refactor` 是结构调整的执行 lane。它的职责是：在不主动改变外部可观察行为的前提下，完成代码结构、依赖关系、模块边界、性能实现或可维护性的改进，并把“行为保持不变”的结论绑定到证据。

它不是 feature lane，也不是 bugfix lane。凡是目标包含“新增能力”“改变产品行为”“顺手修一批历史问题”，都不应伪装成重构。

## When to Use

适用于：

- 拆分过大的模块、函数或文件，改善职责边界
- 消除重复逻辑、坏味道、过深嵌套或难维护控制流
- 调整内部实现方式，如同步改异步、替换内部数据结构、整理依赖注入方式
- 为了可维护性、可测试性、性能或演进空间而重组实现
- 在保持外部契约不变的前提下清理技术债

## When Not to Use

以下情况不要直接进入本 skill：

- 目标本质是新增能力、变更 API、调整用户流程或改变业务规则
- 当前行为本身是错误的，任务实质是修 bug
- 是否允许行为变化并不清楚，或用户口中的“重构”其实混入需求决策
- 任务重点是做架构评审、纯问答、代码评审或需求澄清

遇到这些情况时，优先转交：

- 功能交付：`skills/develop-feature/SKILL.md`
- 缺陷修复：`skills/fix-bug/SKILL.md`
- 架构层评审：`skills/architecture-review/SKILL.md`
- 纯问答：`skills/answer/SKILL.md`
- 方案仍有真实权衡或边界不清：`superpowers:brainstorming`

## Hard Gates

1. 在修改实现前，必须先对齐：`目标 / 范围 / 不做 / 行为边界 / 验收`。
2. 必须先定义“行为边界”，至少覆盖适用项：`公共 API / 输入输出 / 错误语义 / 副作用 / 时序 / 数据兼容性 / 资源特征`。
3. 若行为边界不清、用户可接受的变化范围不清，或疑似存在 `XY` 问题，必须先回到 `superpowers:brainstorming`。
4. 若重构涉及跨模块依赖调整、迁移、回滚风险、并发语义变化、性能敏感路径或大范围文件改动，必须先进入 `superpowers:writing-plans`，不得直接边改边想。
5. 任何可能影响行为的结构调整，都必须受 `superpowers:test-driven-development` 约束；不得先改生产实现再补测试。
6. 不得借重构之名顺手混入 feature、bugfix 扩容、命名体系重写或无关 cleanup。
7. 在没有新鲜验证证据前，不得声称“已完成”“已通过”“production-ready”。

## Operating Loop

1. `Align`
   - 用最短形式回显：`目标 / 范围 / 不做 / 行为边界 / 验收`
   - 若用户只说“帮我重构一下”，先把重构目标具体化，不靠猜测扩范围
2. `Baseline`
   - 收集当前行为证据：测试、接口用法、失败路径、性能基线、调用点、文档契约
   - 若没有足够基线，先补最小保护网，再进入结构调整
3. `Gate`
   - 行为边界不清或方案存在真实权衡：转 `superpowers:brainstorming`
   - 实施路径复杂或存在迁移/回滚风险：转 `superpowers:writing-plans`
   - 进入改动前，按需调用 `superpowers:test-driven-development`
4. `Refactor`
   - 先做最小、可回退的结构调整
   - 每一步只改变一种结构问题，避免把多个风险源绑在一起
   - 保持与仓库现有语言、命名和组织方式一致
5. `Verify`
   - 完成声明前，按 `superpowers:verification-before-completion` 执行验证
   - 至少验证：原始行为未回归、关键边界未破坏、适用的性能或资源特征未明显恶化
6. `Report`
   - 输出 `Done / Partial / Skipped`
   - 明确哪些行为边界已验证、哪些仅有替代证据、哪些仍有残余风险

## Load Only What You Need

按需读取以下规则或技能：

- `rules/deliverable-quality-gate.md`
  - 需要确认代码、脚本或文档类重构的门禁与 `PASS / CONDITIONAL PASS / FAIL` 判定时读取
- `rules/output-style.md`
  - 需要确认对外汇报骨架与措辞边界时读取
- `skills/develop-feature/SKILL.md`
  - 怀疑当前任务已经越界为行为变更或 feature 时读取
- `skills/fix-bug/SKILL.md`
  - 怀疑当前任务本质是修缺陷而不是保行为重构时读取
- `skills/architecture-review/SKILL.md`
  - 怀疑问题根源已上升到系统边界、容量、可靠性或治理层时读取

不要把所有规则与相邻 skill 一次性压进上下文。

## Red Flags

出现以下信号时，说明重构正在退化：

- 还没定义行为边界，就开始大面积改实现
- 以“代码更优雅”为由混入需求变化或历史问题清理
- 没有基线证据，却声称“行为应该没变”
- 把跨模块、跨时序、跨数据边界的改动当成普通 cleanup
- 测试保护不足，却一次性改很多文件或很多责任边界
- 遇到红测后直接改测试去适配新实现，而不是先确认行为边界
- 因为目标是“重构”，就省略性能、资源或并发语义验证

## Deliverable Contract

对用户的交付至少应包含：

- `Done / Partial / Skipped`
- 本次重构的目标对应结果
- 保持不变的行为边界摘要
- 关键结构改动或关键决策
- 验证证据摘要
- 残余风险、限制或后续建议

若当前路径没有更优替代方案，应明确写出：`当前路径合理，暂无更优替代建议。`

## Exit Criteria

- 已明确本次重构的目标、范围、非目标、行为边界与验收
- 路由与升级动作可追溯，不与 `brainstorming / writing-plans / TDD / verification-before-completion` 冲突
- 改动范围保持最小，未混入无关 feature、bugfix 或体系化重写
- 交付结论附带与风险等级匹配的验证证据
- 汇报满足仓库内 `rules/output-style.md` 与 `rules/deliverable-quality-gate.md`
