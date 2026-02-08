---
name: develop-feature
description: 新增功能、端点、UI 流程、集成或数据模型变更时使用。多文件改动专项流程。
---

# 开发功能

## 工作流
1. `superpowers:brainstorming`（跳过条件须**全部**满足：用户请求含明确的输入/输出规格或验收标准 + 实现路径唯一无技术选型分歧 + 改动范围 ≤2 文件且无 schema/API 变更）
2. 涉及 schema/API/鉴权/多模块/迁移 → `superpowers:writing-plans`，落盘 `docs/plans/`
3. `superpowers:test-driven-development`
4. `superpowers:verification-before-completion`
5. **产出物回读**：重新阅读自己写的全部代码，检查遗漏与偏差

## 异常处理
- brainstorming 未达成共识 → 列出分歧点，请用户决策后继续
- 实施中发现计划有重大缺陷 → 暂停实施，更新计划后继续

## 退出标准
- 功能行为符合需求（主路径 + 关键边界均有验证证据）
- 满足通用退出标准（含请求回看、产出物回读、diff 自审）
