---
name: github
description: Use when handling GitHub issues, pull requests, workflow runs, releases, or repo metadata through gh CLI.
argument-hint: "<url | owner/repo#N | issue/pr/run/release request>"
---

# GitHub 集成

生产级 `gh` CLI 操作 SOP。先锁定 `repo + resource + action`，再执行 GitHub 平台侧操作。

## 适用场景
- issue 查看、搜索、评论、编辑、关闭、重开
- PR 查看、搜索、评论、review、编辑、关闭、重开、合并
- workflow run 查看、失败日志、重跑、watch
- release 查看、创建、编辑
- repo 元数据查看
- GitHub commit URL 或 SHA 的只读查询

## 不做
- 本地 `git commit`、`git push`、冲突处理、回滚
- Conventional Commit 或 issue 关联文案生成
- secrets、rulesets、权限治理等仓库管理动作
- repo 或资源类型不明确时的隐式猜测

## 路由边界
- 涉及本地 Git 变更、提交、冲突、回滚：转交 `skills/git/SKILL.md`
- 涉及 GitHub 平台资源查看或操作：使用本 skill
- 混合请求先完成开发或 Git 流程，最后再执行 GitHub 平台动作

## 自动触发
- GitHub URL：`github.com/owner/repo/issues/123`、`/pull/456`、`/commit/abc123`、`/actions/runs/789`
- 短引用：`owner/repo#123`、`#123`
- 关键词请求：`issue 123`、`pr 456`、`run 789`、`release v1.2.3`

## 1) Preflight
- 确认 `gh` 已安装：`gh --version`
- 确认已认证：`gh auth status`
- 需要额外 scope 时，提示 `gh auth refresh -s <scope>`
- 读取操作默认直接执行；写操作先完成风险分级

## 2) Resolve Repo and Resource

先锁定 `repo`，再锁定 `resource`，最后锁定 `action`。

`repo` 解析优先级：
- 完整 GitHub URL
- `owner/repo#N`
- 用户显式写出 `owner/repo`
- 当前工作目录 git remote
- 仍不明确时，先询问 `owner/repo`

`resource` 解析规则：
- `/issues/N` 或 `issue N` -> `issue`
- `/pull/N` 或 `pr N` / `pull request N` -> `pr`
- `/actions/runs/N` 或 `run N` -> `workflow_run`
- `/releases/tag/TAG` 或 `release TAG` -> `release`
- `/commit/SHA` 或 `commit SHA` -> `commit`
- `#N` 或 `owner/repo#N` 且未出现 `issue/pr` 语义 -> 先询问资源类型

硬规则：
- repo 一旦确定，命令统一显式带 `-R owner/repo`
- 禁止把 `#123` 自动当成 issue 或 PR
- GitHub commit URL 一律使用 GitHub API 查询，不降级为本地 `git show`

## 3) Risk Gate

`read`
- view / list / search / checks / logs / status
- 默认直接执行

`low-write`
- comment
- add/remove label
- assign/unassign
- edit title/body/metadata
- rerun workflow
- 用户明确要求动作时可直接执行

`high-write`
- create issue / PR / release
- close / reopen issue
- close / reopen PR
- merge PR
- 任何 admin 或影响分支状态的动作
- 执行前必须回显目标并确认

高风险确认模板：

```markdown
即将执行高风险 GitHub 操作：
- repo: owner/repo
- resource: <issue|pr|release>
- identifier: <N|tag>
- action: <create|close|reopen|merge>
- extra impact: <merge strategy / delete branch / publish release>
请确认是否继续。
```

## 4) Standard Operations

优先使用 `--json` 获取结构化信息并输出摘要；只在日志或交互式场景下使用纯文本输出。

### Issue
- 查看：`gh issue view N -R owner/repo --json number,title,state,author,assignees,labels,comments,url`
- 列表：`gh issue list -R owner/repo --state open --limit 20 --json number,title,state,labels,assignees,updatedAt,url`
- 搜索：`gh search issues QUERY --repo owner/repo --json number,title,state,updatedAt,url`
- 创建：`gh issue create -R owner/repo --title "..." --body "..."`
- 评论：`gh issue comment N -R owner/repo --body "..."`
- 编辑：`gh issue edit N -R owner/repo --title "..." --body "..." --add-label "bug"`
- 关闭：`gh issue close N -R owner/repo`
- 重开：`gh issue reopen N -R owner/repo`

### Pull Request
- 查看：`gh pr view N -R owner/repo --json number,title,state,author,assignees,labels,reviewDecision,mergeable,statusCheckRollup,url`
- 列表：`gh pr list -R owner/repo --state open --limit 20 --json number,title,reviewDecision,updatedAt,url`
- 搜索：`gh search prs QUERY --repo owner/repo --json number,title,state,updatedAt,url`
- checks：`gh pr checks N -R owner/repo --json name,state,workflow,link`
- 评论：`gh pr comment N -R owner/repo --body "..."`
- review：`gh pr review N -R owner/repo --approve|--request-changes|--comment --body "..."`
- 编辑：`gh pr edit N -R owner/repo --title "..." --body "..." --add-label "bug" --add-reviewer reviewer`
- 创建：`gh pr create -R owner/repo --base main --head branch --title "..." --body "..."`。若分支尚未推送或需要本地整理提交，先转交 `skills/git/SKILL.md`
- 关闭：`gh pr close N -R owner/repo`
- 重开：`gh pr reopen N -R owner/repo`
- 合并：`gh pr merge N -R owner/repo --squash|--merge|--rebase`

### Workflow Run
- 查看：`gh run view RUN_ID -R owner/repo --json status,conclusion,jobs,url`
- 失败日志：`gh run view RUN_ID -R owner/repo --log-failed`
- 重跑全部：`gh run rerun RUN_ID -R owner/repo`
- 仅重跑失败任务：`gh run rerun RUN_ID -R owner/repo --failed`
- watch：`gh run watch RUN_ID -R owner/repo --compact --exit-status`

### Release
- 查看：`gh release view TAG -R owner/repo --json tagName,name,isDraft,isPrerelease,publishedAt,url`
- 创建：`gh release create TAG -R owner/repo --title "..." --notes "..."`
- 编辑：`gh release edit TAG -R owner/repo --title "..." --notes "..."`

### Repo Metadata
- 查看仓库：`gh repo view owner/repo --json nameWithOwner,description,defaultBranchRef,viewerPermission,url`

### Commit Context
- GitHub commit URL 或已知 repo 的 SHA：`gh api repos/owner/repo/commits/SHA`
- 裸 SHA 且 repo 不明确：先询问 repo，不做猜测

## 5) Output Format

```markdown
## GitHub Intent
<resource + action + risk>

## Target
repo: <owner/repo>
resource: <issue|pr|workflow_run|release|repo|commit>
identifier: <N|tag|sha|none>

## Command
`gh ...`

## Result
<关键结果摘要>

## Next Step
<继续执行 / 等待确认 / 停止原因>

---
status: <success|partial|blocked>
risk: <read|low-write|high-write>
```

## 6) Error Handling
- `gh` 未安装：提示安装并停止
- 未认证：提示 `gh auth login` 并停止
- scope 不足：提示 `gh auth refresh -s <scope>` 并停止
- repo 不明确：先询问 `owner/repo`
- 资源类型歧义：先询问 issue 或 PR
- 资源不存在：提示检查引用并说明已尝试命令
- 网络错误：输出已尝试命令与错误摘要，提示用户检查网络或代理配置

## 退出标准
- repo、resource、action 都已明确
- 所有命令都使用有效的 `gh` 子命令和参数
- 写操作符合风险门禁
- 输出包含命令、结果摘要、状态与下一步
