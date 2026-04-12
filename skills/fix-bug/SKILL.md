---
name: fix-bug
description: Use when handling repository defects such as regressions, crashes, incorrect output, failing tests, integration breakage, or performance problems that require investigation, repair, and evidence-backed verification.
---

# 修复缺陷

## Overview

`fix-bug` 是缺陷调查与修复的执行 lane，不负责替代需求设计，也不允许在根因未明确前直接进入正式修复。

它的职责是：先对齐问题与影响，再完成复现、调查、修复决策、最小修复、验证与汇报，并把所有修复结论绑定到证据。

## When to Use

适用于：

- 回归、崩溃、错误输出、失败测试、集成异常、性能下降
- 已知存在用户影响、系统影响或交付阻断的缺陷处理
- 需要在仓库上下文中完成调查、修复与回归验证的 bug 工作
- 同时涉及代码与缺陷说明文档的修复交付

## When Not to Use

以下情况不要直接进入本 skill：

- 任务本质是新增能力、需求设计或结构性重构
- 用户主要在问“应该怎么设计”，而不是“为什么坏了、怎么修”
- 问题只是一般性技术问答，不需要进入调查与修复闭环
- 需求本身不清，所谓“bug”实际上是行为未定义或产品决策未定

遇到这些情况时，优先转交：

- 功能开发：`skills/develop-feature/SKILL.md`
- 结构调整：`skills/refactor/SKILL.md`
- 架构评审：`skills/architecture-review/SKILL.md`
- 纯问答：`skills/answer/SKILL.md`

## Hard Gates

1. 在提出正式修复前，必须先对齐：`问题现象 / 影响范围 / 当前证据 / 不做 / 修复判定标准`。
2. 在完成最小复现或最小证据收集前，不得把猜测当成根因。
3. 必须先进入 `superpowers:systematic-debugging` 的调查范式，再决定是否允许修复。
4. 在根因未明确或证据不足时，只允许继续调查、补充仪表化、请求上下文或执行显式 workaround / mitigation；不得伪装成正式修复。
5. 任何正式修复都必须纳入 `superpowers:test-driven-development` 的约束；不得先写生产修复再补测试。
6. 若连续多次修复失败，或问题呈现架构性症状，必须升级路径，不得继续堆补丁。
7. 在没有新鲜验证证据前，不得声称“已修复”“已通过”“production-ready”。

## Operating Loop

1. `Align`
   - 用最短形式回显：`问题 / 影响 / 证据 / 不做 / 修复判定`
   - 用户给出某个“修法”时，先把它降级为假设，而不是直接执行
2. `Reproduce`
   - 明确复现步骤、环境条件、错误信息、日志或失败输出
   - 若无法稳定复现，至少建立最小证据面，再进入调查
3. `Investigate`
   - 进入 `superpowers:systematic-debugging`
   - 查错误、查最近变更、查数据流、形成单一假设并最小化验证
4. `Decide`
   - 根因已确认：进入修复
   - 只有高置信假设：继续调查，不得直接宣称正式修复
   - 无法复现、证据冲突、或多次失败：升级路径
5. `Fix`
   - 用最小改动修根因，不顺手扩大范围
   - workaround、rollback、mitigation 必须显式标识，不得伪装成最终修复
6. `Verify`
   - 完成声明前，按 `superpowers:verification-before-completion` 执行验证
   - 至少验证原始症状、根因场景和回归风险
7. `Report`
   - 输出 `Done / Partial / Skipped`
   - 明确根因状态、修复类型、验证证据摘要和残余风险

## Load Only What You Need

按需读取配套参考文件：

- `references/debugging-escalation-playbook.md`
  - 需要判断当前调查状态、升级条件、允许动作或架构怀疑信号时读取
- `references/bug-recovery-playbook.md`
  - 需要区分 recovery mode、第三方责任边界、范围控制和失败恢复时读取
- `references/verification-checklist.md`
  - 需要判断复现证据、根因证据、修复验证门槛和报告格式时读取

不要把所有参考内容一次性压进上下文。

## Red Flags

出现以下信号时，说明流程正在退化：

- 还没建立复现或证据面就开始写修复
- 把用户提出的修法直接当根因
- 用“先修一下看看”替代调查结论
- 多次失败后继续追加 patch
- workaround 被写成“已修复”
- 回归验证只看“现在不报错了”
- 顺手把 bugfix 扩成 feature 或 refactor

## Deliverable Contract

对用户的交付至少应包含：

- `Done / Partial / Skipped`
- 问题现象与影响范围的对应结果
- 根因状态：`confirmed / likely / unknown`
- 修复类型：`root-cause fix / workaround / rollback / mitigation`
- 验证证据摘要
- 残余风险、限制或后续建议

若当前路径没有更优替代方案，应明确写出：`当前路径合理，暂无更优替代建议。`

## Exit Criteria

- 已明确问题、影响、非目标与修复判定标准
- 调查、修复和验证阶段边界清晰，不与 `systematic-debugging / TDD / verification-before-completion` 冲突
- 修复范围保持最小，未混入无关重构
- 交付结论附带与缺陷类型匹配的证据
- 汇报满足仓库内 `rules/output-style.md` 与 `rules/deliverable-quality-gate.md`
