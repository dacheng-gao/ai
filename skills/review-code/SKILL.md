---
name: review-code
description: 评审代码、PR、diff 或补丁时使用。检查正确性、安全性、性能与可维护性。
---

# 代码评审

找出可阻断合并的问题，给出可执行修复建议。

## 适用与路由
- 评审他人代码：使用本技能
- 接收评审反馈：调用 `superpowers:receiving-code-review`
- 需要二次审阅/门禁时调用 `superpowers:requesting-code-review`

## 检查维度

按 `rules/code-quality.md` 的 Correctness → Security → Performance → Maintainability 逐项检查。评审时额外关注：作者是否提供了 Verification 证据（测试结果、构建日志等）。

## 输出格式

三段式：Findings → Open Questions → Summary

每条 Finding 格式：`<file:line> 严重度: Critical/Important/Suggestion`，附问题、影响、修复。

轻量评审：小改动默认最多输出 Top 5 问题。

无问题时：`未发现阻断问题`，补一句残余风险或测试缺口。

## 退出标准
- 五个维度均已逐项检查，每个维度标注 Pass/Concern
- 发现项已按严重度排序并给出可执行的修复建议（非泛化建议）
- 高风险区域（鉴权、外部输入、数据变更）已显式确认检查
- 满足通用退出标准（请求回看 + 产出物回读）
