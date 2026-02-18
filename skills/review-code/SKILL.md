---
name: review-code
description: 评审代码、PR、diff 或补丁时使用。检查正确性、安全性、性能与可维护性。
argument-hint: "[PR-url | #N | file...]"
---

# 代码评审

## 当前变更（如有）

!`GIT_PAGER=cat git diff --stat 2>/dev/null`

找出可阻断合并的问题。给出可执行的修复建议（非泛化建议）。

## 适用与路由
- 评审他人代码：使用本技能
- 当收到他人对自己代码的评审反馈时 → 调用 `superpowers:receiving-code-review`
- 当完成任务需要二次审阅确认时 → 调用 `superpowers:requesting-code-review`

## Superpowers 调用

| Superpower | 默认 | 跳过条件 |
|------------|------|---------|
| receiving-code-review | 收到评审反馈时 | 无 |
| requesting-code-review | 需二次审阅时 | 无 |

> Superpowers 不可用时：receiving → 逐条回应反馈，验证每条建议的技术正确性后再实施；requesting → 按通用退出标准自审。

## 检查维度

按五维门禁逐项检查。额外关注：
- 作者是否提供了验证证据（测试结果、构建日志等）
- AI 生成代码：幻觉 API 调用、过度工程化、拼凑式逻辑（表面合理但语义错误）

## 输出格式

三段式：Findings → Open Questions → Summary

每条 Finding 格式：`<file:line> 严重度: Critical/Important/Suggestion`，附问题、影响、修复。

轻量评审：小改动默认最多输出 Top 5 问题。

无问题时：`未发现阻断问题`，补一句残余风险或测试缺口。

## 退出标准

| # | 标准 | 验证方式 |
|---|------|---------|
| 1 | 五维门禁已检查 | 每个维度标注 Pass/Concern |
| 2 | 发现项可执行 | 按严重度排序并给出可执行的修复建议（非泛化建议） |
| 3 | 高风险区域已确认 | 鉴权、外部输入、数据变更已显式确认检查 |
