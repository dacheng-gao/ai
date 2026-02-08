---
name: commit-message
description: 生成 git 提交信息时使用。基于 diff 输出 Conventional Commits 格式。
---

# 提交信息生成器

基于 diff 生成 Conventional Commits 提交信息。

## 步骤

1. 获取 diff：`GIT_PAGER=cat git diff --staged`（为空则提示 `git add`）
2. \>300 行 → 建议拆分为多个原子提交
3. 按 `rules/git-workflow.md` 规范生成，只输出代码块
