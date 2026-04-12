# Feature Delivery Playbook

## Purpose

本文件用于细化 `develop-feature` 的交付编排规则：什么时候可以直接执行，什么时候必须升级，什么时候必须停下重新做设计或计划。

它补充主 skill，不替代主 skill。

## Feature Classification

### `small`

满足以下全部条件时，可按小改动处理：

- 需求与验收已明确
- 实现路径单一，无真实方案分歧
- 改动边界局部、责任边界清晰
- 不触及 public API、schema、auth、external integration
- 不涉及高风险用户可见行为变化

默认处理：

- 允许内联简短计划
- 仍需遵守 TDD 与验证门禁

### `standard`

命中以下任一条件，默认按标准功能处理：

- 改动超过单一局部边界
- 触及 user-visible behavior
- 触及 API contract、workflow、permission 或 integration
- 需要代码与文档一起交付
- 回归面较广，但仍可在当前上下文中控制

默认处理：

- 先确认验收，再进入实现
- 若计划尚不清晰，先转 `superpowers:writing-plans`
- 按完整验证矩阵执行

### `high-risk`

命中以下任一条件，升级为高风险：

- schema / migration / data backfill
- auth / permission / ownership logic
- 关键路径性能、并发、一致性或幂等语义变化
- 影响多个模块或多个交付边界
- 回滚困难，或失败成本高

默认处理：

- 先确认设计与计划都已成立
- 不允许靠“边写边想”推进
- 需要更强的风险披露与验证证据

## Mandatory Escalation Conditions

出现以下情况时，必须离开当前执行路径：

- 需求不清，无法定义验收：转 `superpowers:brainstorming`
- 发现存在两个以上真实可行方案，且 trade-off 会影响范围、成本或风险：转 `superpowers:brainstorming`
- 设计已批准，但实施顺序、影响面或回滚路径仍不清：转 `superpowers:writing-plans`
- 实施中发现原设计不成立：停止编码，回到设计或计划阶段

## Implementation Strategy

### `code`

- 先识别行为边界、失败路径、外部依赖和回归面
- 先建立测试保护，再写最小实现
- 若触及公共契约，必须显式检查兼容性与升级路径

### `docs`

- 先确认文档类型、受众和使用场景
- 只写本次 feature 必需的文档，不顺手扩写周边体系
- 回读命令、路径、步骤与当前仓库实现是否一致

### `mixed`

- 先确认代码与文档之间的映射关系
- 代码行为变化未落到文档时，不得判定完成
- 文档承诺超出代码实际能力时，不得判定完成

## Parallel Work Rules

只有在以下条件同时成立时，才考虑并行协作：

- 当前平台与会话策略允许
- 子任务彼此独立
- 写集不重叠
- 责任边界清晰
- 主会话不会被立即阻塞

必须串行的情况：

- 多个改动会落到同一文件
- 需要频繁共享尚未稳定的上下文
- 下一步动作直接依赖某个结果
- 风险集中在单一契约或核心流程

## Failure and Recovery

### 发现范围失控

- 停止继续加需求
- 回到 `目标 / 范围 / 不做`
- 将超出部分明确标为后续项或 `Skipped`

### 发现设计不成立

- 停止继续补丁式实现
- 说明哪条假设失效
- 回到 `superpowers:brainstorming` 或 `superpowers:writing-plans`

### 验证失败

- 不得靠语言弱化失败状态
- 明确是哪项验证失败、影响什么结论
- 修复后重新执行对应验证

### 发现无关结构问题

- 默认不顺手扩大范围
- 仅在其已构成阻断风险时，说明原因并升级范围确认
