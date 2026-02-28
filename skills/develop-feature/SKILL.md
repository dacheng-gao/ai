---
name: develop-feature
description: 新增功能、端点、UI 流程、集成或数据模型变更时使用。多文件改动专项流程。
argument-hint: "[功能描述或需求文档路径]"
---

# 开发功能

## 当前状态

!`git branch --show-current 2>/dev/null && git log --oneline -5 2>/dev/null`
!`git status --short 2>/dev/null | head -20`

## 工作流

1. 目标转换：把需求转为可验证目标，并明确本次不做项
2. `superpowers:brainstorming`（满足以下全部条件可跳过）
   - 输入/输出规格或验收标准明确
   - 实现路径唯一，无选型分歧
   - 改动范围 ≤2 文件且无 schema/API 变更
3. 用 WHEN/THEN 描述行为：至少主路径 + 1 条异常路径（可直接转测试）
4. 制定计划
   - 跨模块或公共契约变更：EnterPlanMode
   - 简单功能（≤3 步、≤2 文件）：内联 3-5 行计划
5. `superpowers:test-driven-development`
6. `superpowers:verification-before-completion`（Typecheck/Build → Lint → Test）

## 特有 Agent 协作

| 场景 | Agent | 执行方式 |
|------|-------|----------|
| 新模块集成且需理解现有架构 | `researcher`(架构) + `researcher`(接口) | 并行 |

## 异常处理
- brainstorming 未达成共识：列出分歧点，请用户决策后继续
- 实施中发现计划重大缺陷：暂停实施，更新计划后继续
- 专属 Superpower 不可用：说明缺失能力，切换等价手动流程并保留验证证据

## 退出标准

| # | 标准 | 验证方式 |
|---|------|---------|
| 1 | 功能行为符合需求 | 主路径 + 关键边界均有验证证据 |
