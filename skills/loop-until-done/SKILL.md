---
name: loop-until-done
description: 不匹配专项技能时的默认工作流：计划→执行→审查→迭代修复→收敛。
---

# 迭代直到完成

未匹配到专项技能时的默认工作流。

## 当前状态

!`git branch --show-current 2>/dev/null && git log --oneline -5 2>/dev/null`
!`git status --short 2>/dev/null | head -20`

## 工作流

### 1. 理解需求
激活适用视角

### 2. 明确目标
- 将请求转为可验证目标（如"优化性能" → "降低 p95 latency → 具体指标"）
- 写清成功标准（可量化时量化）
- 定义范围边界（不做哪些）
- 涉及多文件/模块时列出影响范围

### 3. 计划
- ≥5 步或跨模块 → EnterPlanMode
- 简单任务（≤3 步、≤2 文件）→ 内联 3-5 行编号列表（每行：`N. [动作] [对象]`）

### 4. 执行
按计划完成改动或分析

### 5. 审查
按变更类型选择 reviewer，启动 agent 审查本轮变更：

| 变更类型 | 判断依据 | Agent | 审查指令 |
|---------|---------|-------|---------|
| 提示词文件 | 目标在 `rules/`、`skills/`、`agents/`、`CLAUDE.md`、`AGENTS.md` | `prompt-engineer` | 仅审查，禁止修改文件。输出发现清单（severity + 位置 + 描述），不执行优化 |
| 代码文件 | 其他文件变更 | `reviewer` | 按默认评审流程 |
| 混合变更 | 两类都有 | 两个 agent 并行 | 各按对应审查指令 |

审查完成后向用户展示本轮摘要：

```
## Round N/3 审查结果

**Reviewer**: [agent name]
**Findings**: X Critical, Y Important, Z Suggestion
- [severity] file:line — 描述

继续修复？
```

### 6. 迭代决策

| 条件 | 行为 |
|------|------|
| 无 Critical/Important 发现 | 收敛 → 进入通用退出标准检查 |
| 有 Critical/Important + 轮次 < 3 | 用户确认后回到步骤 4 修复 |
| 有 Critical/Important + 轮次 = 3 | 列出残余风险，强制退出 |
| 用户说"中止" | 立即停止，汇报已完成轮次和残余问题 |

## 特有 Agent 协作

| 场景 | Agent | 执行方式 |
|------|-------|---------|
| 需要多轮搜索理解代码库 | `researcher` | 并行（多线索时） |
| 代码变更审查 | `reviewer` | 步骤 5 自动触发 |
| 提示词变更审查 | `prompt-engineer` | 步骤 5 自动触发 |
| 混合变更审查 | `reviewer` + `prompt-engineer` | 并行 |

## Superpowers 调用

| Superpower | 默认 | 跳过条件 | 说明 |
|------------|------|---------|------|
| writing-plans | ✓ | ≤3 步且 ≤2 文件 | 步骤 3 的计划生成由此驱动（≥5 步时内部使用 EnterPlanMode） |
| verification-before-completion | ✓ | 无 | — |
