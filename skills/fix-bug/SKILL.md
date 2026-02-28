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

1. 目标转换：把缺陷描述转为可验证目标
2. `superpowers:systematic-debugging`：先明确复现条件、复现命令、复现证据
3. `superpowers:test-driven-development`：至少补 1 条覆盖根因的测试
4. `superpowers:verification-before-completion`：回归测试必须覆盖根因场景

## 特有 Agent 协作

| 场景 | Agent | 执行方式 |
|------|-------|----------|
| 多条定位线索 | `researcher`(日志) + `researcher`(代码路径) | 并行 |
| 根因涉及多模块交互 | `researcher`(数据流追踪) | 串行 |

## 异常处理
- 无法复现：列出已尝试方法，请用户补充环境/步骤/日志
- 根因无法确认：列出候选假设和已排除项，请用户补充上下文
- 修复引入回归：回滚修复，重新进入 systematic-debugging
- 多个根因候选：按证据强度排序，先修最可能项并验证
- 根因在第三方代码：提供 workaround，记录上游 issue 链接并标注 TODO
- 连续 3 次修复失败：停止打补丁，升级为架构层面审视并向用户报告
- 专属 Superpower 不可用：改为手动“复现→最小修复→回归验证”并保留证据

## 退出标准

| # | 标准 | 验证方式 |
|---|------|---------|
| 1 | 根因已定位并有证据 | 含复现步骤 + 修复后验证结果 |
| 2 | 修复范围最小化 | diff 中无无关改动 |
