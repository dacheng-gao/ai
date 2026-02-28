---
name: refactor
description: 代码结构调整（性能优化、模块拆分、重写、同步改异步）时使用。保行为、改结构。
argument-hint: "[重构描述或目标]"
---

# 重构

## 当前状态

!`git branch --show-current 2>/dev/null && git log --oneline -5 2>/dev/null`
!`git status --short 2>/dev/null | head -20`
!`git diff HEAD --stat 2>/dev/null | head -30`

## 工作流
1. `superpowers:brainstorming`（满足以下全部条件可跳过）
   - 用户已指定具体重构策略
   - 行为边界明确
   - 改动范围 ≤2 文件且无公共 API 变更
2. 制定计划
   - 跨模块重构（时序变化、迁移、回滚风险）：EnterPlanMode
   - 单模块重构：内联 3-5 行计划
3. `superpowers:test-driven-development`（先建立测试保护）
4. `superpowers:verification-before-completion`

## 特有 Agent 协作

| 场景 | Agent | 执行方式 |
|------|-------|----------|
| 跨模块重构 | `researcher`(模块依赖) + `researcher`(调用链) | 并行 |

## 行为边界（开始前列出，完成后逐项验证）
- 公共 API/返回结构
- 错误语义（类型/状态码/消息）
- 时序与副作用
- 数据兼容性（schema/迁移）
- 资源特征（CPU/内存/I/O）：用基准对比验证；无基准时在退出报告中标注“资源影响未验证”

## 异常处理
- 无法明确行为边界：列出不确定项，请用户确认可接受变化范围
- 重构中测试持续红色：回退到上次绿色状态，缩小重构步幅

## 退出标准

| # | 标准 | 验证方式 |
|---|------|---------|
| 1 | 行为边界已保持 | 清单每项均有验证证据（测试结果或对比说明） |
| 2 | 测试全部通过 | 基线测试 + 新测试 |
