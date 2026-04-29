---
name: git
description: Use when handling local Git CLI daily operations such as checking status or diff, staging files, creating conventional commits, restoring local changes, reverting commits, or resolving merge/rebase/cherry-pick conflicts.
argument-hint: "[本地 git 请求，例如 status / add path / commit / restore file / revert sha / resolve conflict]"
---

# 本地 Git CLI SOP

面向本地 Git 日常操作的生产级 SOP。要求执行简单、显式、基于证据。

## 当前状态

!`git branch --show-current 2>/dev/null && git log --oneline -5 2>/dev/null`
!`git status --short --branch 2>/dev/null | head -20`

## 适用范围

- 用 `status` 和 `diff` 检查本地变更
- 用 `git add` 暂存文件
- 生成 Conventional Commit 并在确认后提交
- 用 `restore` 撤销本地未提交改动
- 用 `revert` 撤销已提交历史
- 处理 merge、rebase、cherry-pick 冲突

## 不适用范围

- 远端协作操作，例如 `fetch`、`pull`、`push`
- 核心闭环之外的本地工作流辅助，例如 stash 或分支管理
- 破坏性历史改写
- GitHub 平台操作

## 1) 预检查

在任何写操作前，先做这些检查：

- 确认当前目录是 Git 仓库：`git rev-parse --is-inside-work-tree`
- 检查分支和工作区：`git status --short --branch`
- 需要时检查 staged 范围：`git diff --staged --stat`
- 需要时识别冲突上下文：
  - `.git/MERGE_HEAD`
  - `.git/rebase-merge`
  - `.git/rebase-apply`
  - `.git/CHERRY_PICK_HEAD`

规则：

- 如果当前目录不是 Git 仓库，立即停止，并报告失败命令
- 需要捕获 diff 输出时，使用 `GIT_PAGER=cat`
- 优先输出摘要，再决定是否展开完整 diff

## 2) 意图路由

把请求明确归到一个意图：

- `inspect`：`status`、`diff`、变更检查、staged 和 unstaged 诊断
- `stage`：`add`、暂存文件、暂存部分 hunks、为 commit 做准备
- `commit`：生成提交信息、检查 staged diff、创建 commit
- `undo`：`restore` 或 `revert`
- `resolve-conflict`：merge、rebase、cherry-pick 冲突处理

如果请求混合了多个意图，按顺序执行，并明确报告每个边界。

## 3) 统一流程

`preflight -> classify -> execute or gate -> verify -> report`

- `execute`：可直接执行的安全读操作，或目标明确的低风险暂存
- `gate`：任何会丢失工作区内容、创建 commit、或结束冲突流程的动作
- `verify`：在声称成功前，运行最小但有效的后续检查
- `report`：输出命令、结果摘要、下一步和最终状态

## 4) 各意图操作手册

### `inspect`

默认命令：

- `git status --short --branch`
- `git diff --stat`
- staged 上下文相关时用 `git diff --staged --stat`

只有摘要不足时，才升级到完整 diff。

行为：

- 纯只读，直接执行
- 先总结，再决定是否输出原始 diff

### `stage`

默认命令：

- `git add <path>`
- 只有用户明确要交互式暂存时才用 `git add -p <path>`

规则：

- 禁止默认执行 `git add .`
- 如果范围不清，先 inspect，再要求用户给出精确路径或明确确认“全部暂存”
- 暂存范围尽量小，保护原子提交

### `commit`

目标：根据 staged diff 生成一条准确的 Conventional Commit。

必走流程：

1. 运行 `git diff --staged --stat`
2. 如果 staged diff 为空，直接以 `blocked` 停止
3. 只在需要时运行 `git diff --staged`，用于准确推导提交信息
4. 生成一条英文 Conventional Commit 候选信息
5. 向用户展示候选信息并等待确认
6. 只有确认后，才执行 `git commit -m "<message>"`，且 message 必须与已展示并确认的完整内容一致

提交规则：

- `type` 只用：`feat|fix|refactor|docs|style|test|chore`
- 使用最准确、最具体的合法 `type`
- `subject` 使用祈使句，简短，不带句号
- `body` 和 `footer` 仅在确实能提升清晰度时才加
- 禁止自动加入 AI 或工具署名、生成声明、协作者 trailer，包括但不限于 `Made-with:`、`Generated-by:`、`Co-Authored-By:` 中指向 `Cursor`、`Claude`、`OpenAI`、`Anthropic` 或其他 AI agent / tool 的内容
- 禁止在确认后追加任何未展示的 `body`、`footer` 或 trailer；只有用户明确逐字要求，或仓库强制策略要求时，才可加入非 AI 署名 trailer
- 如果 staged diff 混入多个不相关改动，应先建议拆分再提交
- 禁止编造 diff 中看不出的产品意图

### `undo`

支持的操作：

- `git restore <path>`
- `git restore --staged <path>`
- 用户明确指定 source 时，可用 `git restore --source=<rev> <path>`
- `git revert <sha>`

规则：

- 必须明确目标范围：working tree、index，或两者
- 如果目标文件或 commit 不清楚，停止并提问，不要猜
- 任何会丢失用户本地改动的 `restore` 都必须显式确认
- 任何 `revert` 在执行前都必须显式确认
- 撤销已提交历史时，优先 `revert`，不要改写历史

### `resolve-conflict`

目标：用最小语义改动完成当前 merge、rebase 或 cherry-pick。

必走流程：

1. 从 Git 状态文件识别上下文
2. 列出未解决文件：`git diff --name-only --diff-filter=U`
3. 编辑前逐个检查冲突文件
4. 只解决冲突，不修改无关代码
5. 清理冲突标记，并暂存已解决文件
6. 对触及范围做最小必要验证
7. 总结解决结果，并等待确认
8. 只有确认后，才执行对应的 continue 命令：
   - `git merge --continue`
   - `git rebase --continue`
   - `git cherry-pick --continue`

规则：

- 如果冲突的业务语义不明确，禁止猜测
- 不要无解释地直接选 `ours` 或 `theirs`
- 如果未解决文件已清空，但 Git 操作实际上不处于活动状态，则以 `blocked` 停止

## 5) 输出格式

```markdown
## 意图
<inspect|stage|commit|undo|resolve-conflict>

## 预检查
<分支、工作区摘要、staged 摘要、相关冲突上下文>

## 执行动作
<已执行或已准备执行的命令>

## 结果
<关键输出摘要、影响文件、生成的 commit message、或已解决冲突>

## 下一步
<最小下一动作，或停止原因>

---
status: <success|partial|blocked|waiting_confirmation>
```

硬规则：

- 如果命令没有执行，就明确写“已准备”或“已提议”
- 需要确认时，状态必须使用 `waiting_confirmation`
- 没有命令证据时，禁止声称成功

## 6) 错误处理

- 不是 Git 仓库：停止，并报告 repo 检查失败的命令
- `add` 目标无效：停止，并报告错误路径
- `commit` 时 staged diff 为空：以 `blocked` 停止
- `restore` 目标不清：停止，并要求明确 scope 或 path
- `revert` 目标不清：停止，并要求提供 commit SHA
- `resolve-conflict` 缺少冲突上下文：停止，并说明未检测到活跃的 merge、rebase 或 cherry-pick
- 命令执行失败：报告精确命令和 stderr 摘要，不要掩盖失败
- commit 推导不充分：给出保守 message，或补问一个缺失信息；禁止幻觉式补全意图

## 7) 退出标准

- 请求始终保持在本地 Git 范围内
- 意图路由明确可解释
- 写操作遵守正确的门禁规则
- 结果都有命令和摘要作为证据
- skill 保持自洽，不依赖外部 agent
