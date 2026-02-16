---
name: fix-bug
description: 处理缺陷、回归、崩溃、错误输出或性能下降时使用。复现→定位→修复→验证。
argument-hint: "[缺陷描述或 issue 链接]"
---

# 修复缺陷

## 当前状态

!`git branch --show-current 2>/dev/null && git log --oneline -5 2>/dev/null`
!`git status --short 2>/dev/null | head -20`

## 工作流

0. **目标转换** — 将缺陷描述转为可验证目标（如"修复登录失败" → "写测试复现失败 → 让测试从 FAIL 变 PASS"）
1. `superpowers:systematic-debugging` — 先说明复现条件与证据
2. `superpowers:test-driven-development` — 必须补至少一条覆盖根因的测试
3. `superpowers:verification-before-completion`

## 特有 Agent 协作

| 场景 | Agent | 执行方式 |
|------|-------|----------|
| 多条定位线索 | `researcher`(日志) + `researcher`(代码路径) | 并行 |
| 根因涉及多模块交互 | `researcher`(数据流追踪) | 串行 |

## 异常处理
- 无法复现 → 列出已尝试的复现方法，请用户提供复现环境/步骤/日志
- 根因无法确认 → 列出候选假设与已排除项，请用户提供更多上下文
- 修复引入新回归 → 回滚修复，重新进入 systematic-debugging
- 多个根因候选 → 按证据强度排序，先修复最可能的，验证后再处理其他
- 根因在第三方代码 → 实现 workaround，记录上游 issue 编号或链接，标注 TODO
- 连续 3 次修复同一问题失败 → 停止 patch，升级为架构层面审视，向用户报告

## 退出标准
- 根因已定位并有证据支撑（含复现步骤 + 修复后验证结果）
- 修复范围最小化（diff 中无无关改动）
