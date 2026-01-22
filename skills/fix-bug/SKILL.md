---
name: fix-bug
description: Use when 处理缺陷、回归、失败测试、崩溃、错误输出、性能下降或不稳定行为（包括需要先补充复现或证据的情况）。
---

# 修复缺陷

## 概述

基于证据定位根因，做最小且安全的修改并验证。仅在高风险/不可逆变更时确认。

## 何时使用

- 失败测试、回归、崩溃、错误输出、性能下降、不稳定行为
- 堆栈、错误日志、异常、超时、带复现步骤的用户报告
- 需要纠正既有行为，而非新增功能

**不适用**
- 新功能或大幅行为变更（用 develop-feature）
- 大范围重构或重新设计（切换到 refactor 流程）

## 核心模式

1. 观察：捕捉精确失败（日志/堆栈/失败测试）
2. 复现：最小复现或定向日志
3. 定位：沿输入 → 失败追踪，找出第一个错误假设
4. 修复：最小变更解决根因
5. 验证：重跑复现 + 相关回归检查

## 快速参考

| 步骤 | 目标 | 证据 |
| --- | --- | --- |
| 观察 | 失败内容与位置 | 堆栈、日志、失败测试 |
| 复现 | 可按需失败 | 最小复现、定向日志 |
| 定位 | 找到第一个错误假设 | 代码跟踪、git bisect |
| 修复 | 最小且安全 | 最小 diff，避免重构 |
| 验证 | 证明已修复 | 测试命令、手动步骤 |

## 实施要点

- 从证据出发，不凭猜测；引用检查过的文件/函数/行号。
- 缺少复现时先补证据（临时日志/失败测试）。
- 优先局部、可回滚变更；范围扩大或风险上升再询问。
- 解释为什么能修复根因（不是只说改了什么）。

**高风险确认条件**
- Destructive or irreversible operations (data deletion, history rewrite, breaking migrations)
- Security/auth or sensitive data handling changes
- Breaking API/contract changes or compatibility risks

## 示例

**症状：** `TypeError: Cannot read properties of undefined (reading 'id')`  
**根因：** 认证 token 过期时 `user` 可能为 `undefined`。  
**修复（最小保护）：**

```ts
// before
const userId = user.id;

// after
if (!user) return res.status(401).end();
const userId = user.id;
```

**验证：** 添加测试 “expired token returns 401” 并重跑失败端点。

## 常见错误

- 只补症状（try/catch）而不定位根因
- 没有复现或证据就猜测
- 为小 bug 做大范围重构
- 跳过验证或回归检查
- 通过禁用测试或加超时来“变绿”

## 借口 vs 事实

| 借口 | 事实 |
| --- | --- |
| “没时间复现” | 盲修会引入回归；做最小复现或日志。 |
| “先加 try/catch 就行” | 只是掩盖失败；应修复错误数据来源。 |
| “为稳妥起见先重构” | 变更越大风险越高；先做最小修复。 |
| “涉及多模块必须先问” | 说明范围变化；仅在风险增加时询问。 |

## 红旗 - 立刻停止

- “先加 try/catch”
- “先禁用测试”
- “无法复现就猜”
- “不如全量重构”
- “不验证就上线”
- “高风险变更未明确确认”
