# Git 工作流

## 全局约束
- 禁止使用 `git worktree`；仅在当前主工作区修改。
- 未获得用户明确批准，不执行 `git commit`（包含 amend/rebase 产生的新提交）。
- 即便用户要求“直接 commit”或时间紧迫，也必须先请求批准。
