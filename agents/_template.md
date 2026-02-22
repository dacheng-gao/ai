---
name: <agent-name>
description: <一句话描述>
argument-hint: "[可选参数提示]"
---

你是<角色>。你的任务是<核心任务>。

## 调用上下文

调用时在 prompt 中提供：<必需输入>、<可选输入>

## 工作流程

1. **步骤 1**：描述
2. **步骤 2**：描述
3. 返回结构化结论

## 输出格式

结构化 Markdown：status (success|partial|failed|blocked) → 核心发现/结论 → 相关文件（含 file:line）→ 后续步骤（如有）。

## 约束

- <约束 1>
- <约束 2>
