---
name: git
description: 智能化 Git 操作。覆盖提交、冲突处理与安全回滚；提交场景委派 git-committer agent。
argument-hint: "[操作描述，如 commit / resolve conflict / rollback]"
---

# Git 智能操作

## 当前状态

!`git branch --show-current 2>/dev/null && git log --oneline -5 2>/dev/null`
!`git status --short 2>/dev/null | head -20`

## 适用场景
- 生成 Conventional Commit message 并在用户同意后提交
- 处理 merge/rebase/cherry-pick 冲突
- 安全回滚（revert/restore）
- Git 状态与历史排查

## 路由规则
1. 含 `commit`/`提交`/`message` → 流程 A（智能提交）
2. 含 `conflict`/`冲突`/`merge`/`rebase`/`cherry-pick` → 流程 B（冲突处理）
3. 含 `revert`/`restore`/`回滚`/`撤销` → 流程 C（安全回滚）
4. 其他 Git 请求 → 输出诊断摘要 + 最小可执行命令

## 流程 A：智能提交（委派 git-committer）
1. 检查变更
   - `git status --short`
   - `GIT_PAGER=cat git diff --staged --stat`
2. staged 为空时
   - 有 unstaged：建议 `git add -p` 或 `git add <file>`
   - 无任何变更：返回 `blocked`
3. 调用 `git-committer` agent
   - 基于 staged diff 生成 Conventional Commit message
   - 向用户确认（确认提交 / 编辑后提交 / 取消）
   - 仅在用户确认后执行 `git commit`
4. 返回提交结果（commit hash + message）

## 流程 B：冲突处理
1. 识别上下文
   - `git status --short`
   - 检测 `.git/MERGE_HEAD`、`.git/rebase-merge`、`.git/rebase-apply`、`.git/CHERRY_PICK_HEAD`
2. 收集冲突文件
   - `git diff --name-only --diff-filter=U`
   - 为空则返回 `blocked`
3. 解决策略
   - 最小语义变更，禁止顺手重构
   - 清理冲突标记（`<<<<<<<` / `=======` / `>>>>>>>`）
   - 无法判断业务语义时，一次性确认关键分歧
4. 大规模冲突（>5 文件或跨多个模块）触发 `superagents` 协调 implementer/reviewer
5. 解决后执行
   - `git add <resolved-files>`
   - 运行最小必要验证（相关测试/构建/lint）
   - 执行 `git merge --continue` / `git rebase --continue` / `git cherry-pick --continue`

## 流程 C：安全回滚
- 默认优先 `git revert` 与 `git restore`
- `git reset --hard`、`git clean -fd` 属破坏性操作，必须用户明确确认
- 改写历史前先建议创建安全分支：`git branch backup/<timestamp>`

## 约束
- 未获用户同意前，禁止执行 `git commit`
- 禁止执行未请求的破坏性 Git 命令
- 冲突修复仅改必要代码，不引入范围外改动
- 结论必须附命令与输出摘要证据

## 输出格式

```markdown
## 意图识别
<commit|conflict|rollback|diagnose>

## 执行结果
<关键命令、输出摘要、影响文件>

## 下一步
<最小可执行步骤>

---
status: <success|partial|blocked>
```

## 退出标准

| # | 标准 | 验证方式 |
|---|------|---------|
| 1 | 路由命中正确 | 意图与流程 A/B/C/diagnose 一致 |
| 2 | 关键结论有证据 | 包含关键命令与输出摘要 |
| 3 | 危险操作已确认 | 破坏性命令前有明确用户确认 |
| 4 | 状态可解释 | `success/partial/blocked` 与结果一致 |
