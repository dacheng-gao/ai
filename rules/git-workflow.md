# Git 工作流

## 全局约束
- 禁止使用 `git worktree`；仅在当前主工作区修改。
- 未获得用户明确批准，不执行 `git commit`（包含 amend/rebase 产生的新提交）。任何未获准的 commit 均属违规。
- 即便用户要求“直接 commit”或时间紧迫，也必须先请求批准。未获准直接提交将导致任务失败。

## 提交信息规范 (Conventional Commits)
提交信息必须遵循 [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) 规范，并使用**英文**书写。

### 常用类型 (Type)
- `feat`: 新功能
- `fix`: 修补 bug
- `docs`: 文档变更
- `style`: 不影响代码含义的变更（空白、格式、缺少分号等）
- `refactor`: 重构（既不是修补 bug 也不加新功能）
- `perf`: 性能优化
- `test`: 添加缺失测试或更正现有测试
- `chore`: 对构建过程或辅助工具和库（如文档生成）的更改

### 示例
```bash
feat(auth): add password strength validation
fix(api): handle null response in user profile
docs(readme): update installation instructions
refactor(icons): migrate to SVG components
```

## 分步提交
- 优先选择分步提交（Atomic Commits），避免一个巨大的提交。
- 每个逻辑变更一个提交，便于回滚和审计。
