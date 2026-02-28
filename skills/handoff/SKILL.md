---
name: handoff
description: 跨会话交接、上下文保存或长任务中断续接时使用。结构化保存→新会话恢复。
argument-hint: "[任务描述]"
---

# 跨会话交接

## 当前状态

!`git branch --show-current 2>/dev/null && git log --oneline -5 2>/dev/null`
!`git status --short 2>/dev/null | head -20`

## 触发时机
- 用户明确要求保存进度或交接
- 长任务接近上下文窗口上限
- 完成一个逻辑阶段，准备进入下一阶段
- 当日结束，次日需继续

## 保存流程
1. 写入 HANDOFF 文件：优先 `.claude/HANDOFF.md`，不存在则 `HANDOFF.md`
2. 有未提交代码变更时委派 `git-committer` 提交；无变更则跳过
3. 告知用户文件位置与恢复方式

## HANDOFF 格式

```markdown
## HANDOFF — [任务名]

### 已完成
- [x] 步骤描述：结果摘要

### 进行中
- 当前分支：`<branch>` @ `<commit-sha>`
- 当前状态：描述

### 下一步（可验证目标）
1. 目标描述 → 期望结果
2. 目标描述 → 期望结果

### 注意事项
- 已知风险 / 设计决策 / 依赖 / 阻塞点
```

## 恢复流程
1. 读取 HANDOFF，跳过“已完成”
2. 验证“进行中”中的分支与代码状态
3. 从“下一步”的第一个目标继续执行

## 退出标准
- HANDOFF 文件已写入，且包含全部必需章节
- 若存在代码变更：已提交到对应分支；若无代码变更：结果中已明确说明
