---
name: review-code
description: 评审代码、PR、diff 或补丁时使用。检查正确性、安全性、性能与可维护性。
argument-hint: "[PR-url | #N | file...]"
---

# 代码评审

## 当前变更（如有）

!`GIT_PAGER=cat git diff --stat 2>/dev/null`

目标：找出可阻断合并的问题，并给出可执行修复建议。

## 内部路由
- 收到他人对自己代码的评审反馈：`superpowers:receiving-code-review`
- 完成任务需要二次审阅确认：`superpowers:requesting-code-review`

## Superpowers 调用

| Superpower | 默认 | 跳过条件 |
|------------|------|---------|
| receiving-code-review | 收到评审反馈时 | 无 |
| requesting-code-review | 需二次审阅时 | 无 |

## 核心流程
1. 确认评审范围（PR/diff/文件列表）与评审目标
2. 收集最小必要证据（相关 diff、上下文、验证结果）
3. 按五维门禁与高风险区域执行检查
4. 输出按严重度排序的 findings 与可执行修复建议

## 检查维度
- 按 `rules/code-quality.md` 五维门禁：正确性、安全、性能、可维护性、验证
- 验证证据是否充分（测试结果、构建日志等）
- AI 生成代码风险：幻觉 API、过度工程、拼凑逻辑
- 高风险区域：鉴权、外部输入、数据变更、脚本权限、命令执行路径

## 输出格式
- 三段式：Findings → Open Questions → Summary
- 每条 Finding：`<file:line> 严重度: Critical/Important/Suggestion` + 问题/影响/修复
- 小改动默认最多输出 Top 5 问题
- 无问题时输出：`未发现阻断问题`，并补充残余风险或测试缺口

## 退出标准

| # | 标准 | 验证方式 |
|---|------|---------|
| 1 | 五维门禁已检查 | 正确性/安全/性能/可维护性/验证各标注 Pass/Concern |
| 2 | 发现项可执行 | 按严重度排序并给出可执行修复建议 |
| 3 | 高风险区域已确认 | 鉴权、外部输入、数据变更已显式确认检查 |
