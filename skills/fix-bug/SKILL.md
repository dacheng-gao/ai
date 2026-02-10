---
name: fix-bug
description: 处理缺陷、回归、崩溃、错误输出或性能下降时使用。复现→定位→修复→验证。
---

# 修复缺陷

## 工作流

1. `superpowers:systematic-debugging` — 先说明复现条件与证据
2. `superpowers:test-driven-development` — 必须补至少一条覆盖根因的测试
3. `superpowers:verification-before-completion`

## 异常处理
- 根因无法确认 → 列出候选假设与已排除项，请用户提供更多上下文
- 修复引入新回归 → 回滚修复，重新进入 systematic-debugging
- 多个根因候选 → 按证据强度排序，先修复最可能的，验证后再处理其他
- 根因在第三方代码 → 实现 workaround，记录上游 issue 编号或链接，标注 TODO

## 退出标准
- 根因已定位并有证据支撑（含复现步骤 + 修复后验证结果）
- 修复范围最小化（diff 中无无关改动）
