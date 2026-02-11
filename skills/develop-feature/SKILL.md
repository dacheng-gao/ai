---
name: develop-feature
description: 新增功能、端点、UI 流程、集成或数据模型变更时使用。多文件改动专项流程。
---

# 开发功能

## 工作流

0. **目标转换** — 将功能描述转为可验证目标（如"添加缓存" → "基准 latency → 实现缓存 → latency 降低 >50%"）
1. `superpowers:brainstorming`（以下条件**全部**满足时可跳过）：
   - 用户请求含明确的输入/输出规格或验收标准
   - 实现路径唯一，无技术选型分歧
   - 改动范围 ≤2 文件且无 schema/API 变更
2. 用 WHEN/THEN 场景描述关键行为（每条场景可直接转为测试用例）
3. 涉及 schema / API / 鉴权 / 多模块 / 迁移 → 调用 `superpowers:writing-plans`，落盘到项目约定目录（默认 `docs/plans/`，不存在时询问用户）；否则跳过
4. `superpowers:test-driven-development`
5. `superpowers:verification-before-completion`

## 异常处理
- brainstorming 未达成共识 → 列出分歧点，请用户决策后继续
- 实施中发现计划有重大缺陷 → 暂停实施，更新计划后继续

## 退出标准
- 功能行为符合需求（主路径 + 关键边界均有验证证据）
