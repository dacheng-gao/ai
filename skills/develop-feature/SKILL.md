---
name: develop-feature
description: 新增功能、端点、UI 流程、集成或数据模型变更时使用。多文件改动专项流程。
---

# 开发功能

## 工作流
1. 需求有歧义或存在多方案可选 → `superpowers:brainstorming`（需求明确且单一方案时跳过）
2. 涉及 schema/API/鉴权/多模块/迁移 → `superpowers:writing-plans`，落盘 `docs/plans/`
3. `superpowers:test-driven-development`
4. `superpowers:verification-before-completion`

## 异常处理
- brainstorming 未达成共识 → 列出分歧点，请用户决策后继续
- 实施中发现计划有重大缺陷 → 暂停实施，更新计划后继续

## 退出标准
- 功能行为符合需求（主路径 + 关键边界）
- 满足通用退出标准
