---
name: software-architecture
description: >-
  Design or review system architecture using quality requirements, system boundaries,
  failure behavior, technology experiments and migration constraints. Use for
  system-level tradeoffs or feasibility risks. Exclude routine coding, settled
  diagram edits and module-only refactoring without system-level consequences.
---

# 系统架构与技术验证

让重要质量要求有可解释的实现路径，使高代价决定能够被证据检验。保留已有架构与约束，按当前问题决定分析深度。

## 找出架构驱动因素

从当前系统、需求、依赖契约、运行测量和已有决定中识别受影响边界。明确需要改善的行为，以及兼容、部署环境、团队维护能力、预算或期限中已知的限制。不从“高并发”“高可用”推造数值，不从框架流行度推导架构。

把最重要的质量要求写成具体场景：来源/触发、环境、受影响对象、期望响应、判定尺度。没有目标值时列为待确认，仍可分析结构与可行性。使用 [decisions.md](references/decisions.md) 展开质量场景、权衡、C4/ADR 和技术试验。

## 从责任到结构

明确事实与规则由谁拥有、调用方向、同步或异步边界、需要的事务与失败语义。业务语义未定时先澄清；模块信息隐藏使用现有 `software-design-philosophy`，数据库约束/并发协议使用 `database-design`，无需重复其工作。

画图只为回答当前读者的问题：系统上下文解释外部参与者，容器视图解释可运行单元和存储，动态视图解释交互，部署视图解释运行位置。C4 的 container 不专指 Docker。不要为形式完整画全套层级。

对重要且有选择空间的决定，比较真实可行方案，包括保留或渐进修改现状的方案。说明收益、代价、失败行为、运维负担和什么证据会改变结论；明显的局部选择无需比较表。

优先验证能够推翻方案的未知：供应商能力、关键延迟、数据迁移可行性或隔离保证。试验围绕一个明确问题和判定依据展开；实验代码不自动成为生产代码，样本表现不自动证明生产容量。

## 演进与验证

变更公开接口、事件或存储时，检查生产者/消费者、旧新版本共存、回填、切换与故障恢复；说明哪些动作不可逆，回滚应用是否足以恢复。请求仅为设计时交付可审查方案，不实际发布或迁移。

通过关键业务流和失败路径走查，检查责任是否完整、约束是否可执行、质量目标是否对应验证方法。重大决定需要长期保留理由时更新项目 ADR；状态仍是提案就明确写提案。

交付结论、必要视图/契约、关键取舍与证据、实施顺序和未决风险。当它们足以支持当前决定或授权实现时停止，不为了预想规模增加分布式组件。

主要来源为 Bass/Clements/Kazman 的质量属性方法、Brown 的 C4、Nygard 的 ADR；详见 [来源映射](../software-delivery/references/sources.md)。
