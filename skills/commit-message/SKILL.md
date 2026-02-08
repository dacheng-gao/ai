---
name: commit-message
description: 生成 git 提交信息时使用。基于 diff 输出 Conventional Commits 格式。
---

# 提交信息生成器

基于 diff 生成 Conventional Commits 提交信息。

## 步骤

1. 获取 diff：`GIT_PAGER=cat git diff --staged`（为空则提示 `git add`）
2. \>300 行 → 建议拆分为多个原子提交
3. 按 `rules/git-workflow.md` 规范生成提交信息
4. **必须等待用户确认**：询问 "使用此提交信息？(y/n/edit)"
5. 用户确认后再执行 `git commit -m "message"`

## 约束

- 执行 `git commit` 前必须输出 message 给用户确认，禁止未经确认直接执行
- 提交信息必须符合 `rules/git-workflow.md` 全部规范
- diff 内容与提交信息必须一致：type 准确反映变更性质，scope 准确反映变更范围
