---
name: develop-feature
description: Use when 需要新增功能、端点、UI 流程、集成或数据模型变更，且涉及多文件影响或需求不清，需要范围规划。
---

# 开发功能

## 概述
两阶段：调研/规划 → 实施 + 验证。计划完成后默认继续，除非触发高风险确认。

## 何时使用
- 新功能、增强、端点、UI 流程、集成、数据模型
- 多文件改动或需求不清

**不适用**
- 仅修 bug → 用 fix-bug；仅重构 → 用 refactor

## 必需子技能
- **REQUIRED SUB-SKILL:** superpowers:verification-before-completion

## 快速参考
| 阶段 | 关口 | 输出 |
|---|---|---|
| 1. 规划 | 风险检查（仅高风险确认） | 证据、方案、范围 |
| 2. 实施 | 测试 + 验证 | 代码 + 测试、验证、偏差说明 |

## 阶段 1：规划与设计

**规则：**
- 阶段 1 不写实现代码或测试
- 引用证据（路径/函数/模式）
- 信息缺失 → 搜索或询问
- 若被要求跳过规划，拒绝；给出计划并默认继续，除非触发高风险确认

**强制上下文清单**
- 范围 + 成功标准
- 架构文档：`AGENTS.md`, `README.md`, `docs/`
- 既有模式/工具（引用文件/函数）
- 依赖/约束 + 集成点 + 未决问题

**实施计划必须包含**
1. **摘要** — 做什么/为什么，成功标准
2. **证据** — 已检查文件、模式/工具、约束
3. **方案 + 范围** — 备选、权衡、文件、测试、边界条件、兼容性、性能、安全、发布/回滚

**阶段 1 结尾语**
> "Plan ready. I will proceed unless you want changes. If any High-Risk Confirmation Triggers apply, I will ask explicitly before implementation."

**高风险确认条件**
- Destructive or irreversible operations (data deletion, history rewrite, breaking migrations)
- Security/auth changes, access control, or sensitive data handling
- Breaking API/contract changes or compatibility risks
- Scope expands beyond the agreed plan in a way that increases risk

---

## 阶段 2：实施

**规则：**
- 计划完成后进入；仅高风险需明确确认
- 遵循测试与验证；风险或范围提升时再确认

**实施清单**
- 遵循已批准设计；记录偏差及理由
- 补齐必要测试，覆盖关键路径与边界
- 匹配既有模式；处理错误
- 在完成声明前运行测试 + lint/format
- 提供验证步骤

**如果你在计划前已写代码**
删除或暂存并回到阶段 1。补写计划属于违规。

## 示例计划
```markdown
Requirement: CSV export on Reports page
Success: download CSV A,B,C <2s
Research: ReportPage.tsx; reports API; utils/csv.ts
Approach: client-side export (rec) /reports/export endpoint
Scope: ReportPage + ReportPage.test.tsx
Considerations: 10k cap, permissions
```

## 常见错误与借口
| 想法 | 事实 |
|---|---|
| “很小/很急，可以跳过计划” | 跳过计划会交付错误结果，仍需计划。 |
| “我先写了代码/先做小试探” | 补写计划 ≠ 计划。回到阶段 1。 |
| “我默认处理或跳过问题” | 假设会导致返工，需询问/调研。 |
| “测试可以后补” | 测试不应后置，至少覆盖关键路径与回归。 |
| “我每次都要先请求批准” | 仅在触发高风险确认条件时询问，否则默认继续。 |

## 红旗 - 立刻停止
- 在阶段 1 计划前就开始实现或测试
- 研究结论无法引用文件路径或函数
- 在猜测需求、边界或约束
- 被要求跳过规划或“直接打补丁”
- 即将执行高风险确认事项却没有明确确认
