---
name: loop-until-done
description: 不匹配专项技能时的默认工作流：计划→执行→审查→迭代修复→收敛。
---

# 迭代直到完成

未匹配专项技能时使用本流程。

## 当前状态

!`git branch --show-current 2>/dev/null && git log --oneline -5 2>/dev/null`
!`git status --short 2>/dev/null | head -20`

## 工作流

1. 理解需求并激活适用视角
2. 明确目标
   - 将请求转为可验证目标（可量化则量化）
   - 写清成功标准
   - 明确范围边界与影响范围（多文件/多模块时）
3. 制定计划
   - ≥5 步或跨模块：EnterPlanMode
   - 简单任务（≤3 步、≤2 文件）：内联 3-5 行计划（`N. [动作] [对象]`）
4. 执行：按计划完成改动或分析
5. 审查：按变更类型调用对应 agent

| 变更类型 | 判断依据 | Agent | 审查指令 |
|---------|---------|-------|---------|
| 提示词文件 | 目标在 `rules/`、`skills/`、`agents/`、`CLAUDE.md`、`AGENTS.md` | `prompt-engineer` | 仅审查，禁止修改；输出 findings（severity + 位置 + 描述） |
| 代码文件 | 其他文件变更 | `reviewer` | 按默认评审流程 |
| 混合变更 | 两类都有 | 两个 agent 并行 | 各按对应审查指令 |

审查结果展示：

```markdown
## Round N/3 审查结果

**Reviewer**: [agent name]
**Findings**: X Critical, Y Important, Z Suggestion
- [severity] file:line — 描述
```

6. 迭代决策

| 条件 | 行为 |
|------|------|
| 无 Critical/Important | 收敛，进入通用退出标准检查 |
| 有 Critical/Important 且轮次 < 3 | 默认直接回到步骤 4 修复；仅在业务决策/破坏性操作时询问用户 |
| 有 Critical/Important 且轮次 = 3 | 列出残余风险，强制退出 |
| 用户说“中止” | 立即停止并汇报已完成轮次和残余问题 |

## 特有 Agent 协作

| 场景 | Agent | 执行方式 |
|------|-------|---------|
| 多线索搜索代码库 | `researcher` | 并行（多线索时） |
| 代码变更审查 | `reviewer` | 步骤 5 自动触发 |
| 提示词变更审查 | `prompt-engineer` | 步骤 5 自动触发 |
| 混合变更审查 | `reviewer` + `prompt-engineer` | 并行 |

## Superpowers 调用

| Superpower | 默认 | 跳过条件 | 说明 |
|------------|------|---------|------|
| writing-plans | ✓ | ≤3 步且 ≤2 文件 | 计划生成（≥5 步时内部使用 EnterPlanMode） |
| verification-before-completion | ✓ | 无 | 收敛前必须完成 |

## 退出标准

| # | 标准 | 验证方式 |
|---|------|---------|
| 1 | 请求条目已对照 | Done/Partial/Skipped 清单 |
| 2 | 关键结论可追溯 | `file:line`、命令或链接证据 |
| 3 | 质量门禁已完成 | 正确性/安全/性能/可维护性/验证 |
| 4 | 残余风险透明 | 未完成项与影响已显式列出 |
