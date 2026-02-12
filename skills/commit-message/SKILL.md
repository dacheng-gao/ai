---
name: commit-message
description: 生成 git 提交信息时使用。基于 diff 输出 Conventional Commits 格式。
argument-hint: "[--all | <file>...]"
---

# 提交信息生成器

## 当前 Staged 变更

!`GIT_PAGER=cat git diff --staged --stat 2>/dev/null || echo "（无 staged 变更，请先 git add）"`

## 工作流

1. 获取 diff：`GIT_PAGER=cat git diff --staged`（为空则提示 `git add`）
2. \>300 行 → 建议拆分为多个原子提交
3. 按 `rules/git-workflow.md` 规范生成提交信息
4. **必须等待用户确认**：询问 "使用此提交信息？(y/n/edit)"
5. 用户确认后再执行 `git commit -m "message"`

## 约束

- diff 内容与提交信息必须一致：type 准确反映变更性质，scope 准确反映变更范围

## 退出标准
- 提交信息已获用户确认并成功执行
