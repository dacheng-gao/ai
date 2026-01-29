---
name: develop-feature
description: 当需要新增功能、端点、UI 流程、集成或数据模型变更，且涉及多文件影响或需求不清，需要范围规划时使用。
---

# 开发功能

## 概述

**这是一个编排技能** - 组织 superpowers 基础技能来完成功能开发流程。

本项目依赖 [superpowers plugin](https://github.com/obra/superpowers) 提供的基础开发流程。

## 必需子技能 (REQUIRED SUB-SKILLS)

按以下顺序调用：

1. **superpowers:brainstorming** - 探索需求和设计
   - 理解用户意图
   - 提出方案选项
   - 确认设计

2. **superpowers:writing-plans** - 编写详细实施计划
   - 分解为 bite-sized 任务
   - 指定文件路径和测试
   - 保存到 `docs/plans/`

3. **superpowers:test-driven-development** - TDD 实施
   - RED → GREEN → REFACTOR

4. **superpowers:verification-before-completion** - 完成前验证

## 快速参考

| 阶段 | 调用技能 | 输出 |
|---|---|---|
| 1. 探索 | brainstorming | 设计文档 |
| 2. 计划 | writing-plans | 实施计划 |
| 3. 实施 | test-driven-development | 代码 + 测试 |
| 4. 验证 | verification-before-completion | 验证证据 |

## 何时使用

- 新功能、增强、端点、UI 流程、集成、数据模型
- 多文件改动或需求不清

**不适用：** 仅修 bug → fix-bug；仅重构 → refactor

## 工作流程

```
用户请求功能
       ↓
调用 superpowers:brainstorming
       ↓
   设计确认
       ↓
调用 superpowers:writing-plans
       ↓
   计划保存到 docs/plans/
       ↓
   选择执行方式
       ↓
┌──────┴──────┐
│             │
Subagent    Parallel
Driven      Session
│             │
↓             ↓
调用          新会话调用
subagent-    executing-plans
driven-dev
       ↓
调用 superpowers:test-driven-development
       ↓
调用 superpowers:verification-before-completion
       ↓
   完成
```

## 执行选项

在 writing-plans 完成后，询问用户：

**"计划已保存到 `docs/plans/<文件>.md`。两种执行方式：**

1. **Subagent 驱动（当前会话）** - 每个 task 一个 fresh subagent，task 间评审
2. **并行会话（独立）** - 新会话用 executing-plans，批量执行**

选择哪种？"

- 如果选 1：调用 `superpowers:subagent-driven-development`
- 如果选 2：指导用户创建新会话，使用 `superpowers:executing-plans`

## 项目特定补充

在 superpowers 技能基础上，本项目额外要求：

- [ ] 设计文档保存在 `docs/plans/YYYY-MM-DD-<名称>-design.md`
- [ ] 实施计划保存在 `docs/plans/YYYY-MM-DD-<名称>.md`
- [ ] 符合项目代码风格和模式
- [ ] 遵循项目语言规则（中文描述，英文代码）

## 完成标准

- [ ] brainstorming 完成设计探索
- [ ] writing-plans 完成详细计划
- [ ] TDD 循环完成
- [ ] 所有测试通过
- [ ] verification-before-completion 通过

## 高风险确认条件

仅在触发以下条件时需明确用户批准：

- 破坏性或不可逆操作（数据删除、历史重写、破坏性迁移）
- 安全、鉴权变更，访问控制或敏感数据处理
- 破坏 API、契约或兼容性风险
- 范围超出既定计划且增加了风险

**其他情况：** 设计和计划完成后默认继续实施

## 常见错误

### 流程违规
- 跳过 brainstorming 直接写计划
- 跳过 writing-plans 直接写代码
- 计划前就开始实现或测试

### 调用问题
- 只说"用 superpowers"但不指定具体技能名
- 调用顺序错误
- 中途跳过步骤

## 借口 vs 事实

| 借口 | 事实 |
| --- | --- |
| "需求很明确，不需要探索" | 明确的需求也有设计权衡，brainstorming 确保无遗漏。 |
| "直接写代码更快" | 无计划的代码经常返工，writing-plans 预先发现风险。 |
| "superpowers 太重了" | 重的是返工，不是规划。 |
| "我边做边想" | 边做边想 = 边返工，成本更高。 |

## 红旗 - 立即停止

- 写计划前未调用 brainstorming
- 写代码前未调用 writing-plans
- 写代码前未调用 test-driven-development
- 说"用 superpowers"但不指定具体技能名

## 与原技能的区别

**原版本：** 自定义两阶段流程（规划 → 实施）

**新版本：** 编排者模式，调用 superpowers 技能

好处：
- 设计探索与计划编写由专门技能处理
- 执行方式更灵活（subagent 或 parallel session）
- superpowers 更新时自动受益
