---
name: refactor
description: 代码结构调整（性能优化、模块拆分、重写、同步改异步）时使用。保行为、改结构。
---

# 重构

## 工作流
1. `superpowers:brainstorming`（明确边界与策略）
2. `superpowers:test-driven-development`（测试保护）
3. `superpowers:verification-before-completion`

`superpowers:writing-plans` 仅在复杂重构时强制：跨模块、时序变化、迁移或回滚风险。

## 行为边界（必须显式列出）
- 公共 API/返回结构
- 错误语义（错误类型/状态码/消息）
- 时序与副作用
- 数据兼容性（schema/迁移）
- 资源特征（CPU/内存/I/O）

## 异常处理
- 无法明确行为边界 → 列出不确定项，请用户确认可接受的行为变化范围
- 重构中测试持续红色 → 回退到上次绿色状态，缩小重构步幅

## 退出标准
- 所有行为边界已逐项验证
- 基线测试 + 新测试全部通过
- 满足通用退出标准
