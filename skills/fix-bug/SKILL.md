---
name: fix-bug
description: 处理缺陷、回归、崩溃、错误输出或性能下降时使用。复现→定位→修复→验证。
---

# 修复缺陷

## 工作流
1. `superpowers:systematic-debugging` — 先说明复现条件与证据
2. `superpowers:test-driven-development` — 至少补一条覆盖根因的测试
3. `superpowers:verification-before-completion`

## 异常处理
- 根因无法确认 → 列出候选假设与已排除项，请用户提供更多上下文
- 修复引入新回归 → 回滚修复，重新进入 systematic-debugging

## 退出标准
- 根因已定位并有证据支撑
- 修复范围最小化
- 满足通用退出标准
