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

0. **目标转换** — 将功能描述转为可验证目标（如"添加缓存" → "基准 latency → 实现缓存 → latency 降低 >50%"）
1. `superpowers:brainstorming`（以下条件**全部**满足时可跳过）：
   - 用户请求含明确的输入/输出规格或验收标准
   - 实现路径唯一，无技术选型分歧
   - 改动范围 ≤2 文件且无 schema/API 变更
2. 用 WHEN/THEN 场景描述关键行为（每条场景可直接转为测试用例）
3. **计划**：
   - 跨模块或涉及公共契约变更 → EnterPlanMode
   - 简单功能（≤3 步、≤2 文件）→ 内联 3-5 行计划
4. `superpowers:test-driven-development`
5. `superpowers:verification-before-completion`

## Superpowers 调用

| Superpower | 默认 | 跳过条件 |
|------------|------|---------|
| brainstorming | ✓ | 明确规格 + 唯一路径 + ≤2 文件 + 无 API 变更 |
| test-driven-development | ✓ | 无 |
| verification-before-completion | ✓ | 无 |

## 特有 Agent 协作

| 场景 | Agent | 执行方式 |
|------|-------|----------|
| 新模块集成，需理解现有架构 | `researcher`(架构) + `researcher`(接口) | 并行 |

## 异常处理
- brainstorming 未达成共识 → 列出分歧点，请用户决策后继续
- 实施中发现计划有重大缺陷 → 暂停实施，更新计划后继续

## 退出标准

| # | 标准 | 验证方式 |
|---|------|---------|
| 1 | 功能行为符合需求 | 主路径 + 关键边界均有验证证据 |
