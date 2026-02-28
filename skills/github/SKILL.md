---
name: github
description: GitHub 集成。识别 GitHub 链接、使用 gh CLI 获取上下文、关联到 commit、执行 GitHub 操作。自动触发。
argument-hint: "<url | #issue | PR N>"
---

# GitHub 集成

使用 `gh` CLI 识别 GitHub 资源、获取上下文并执行操作。

## 自动触发
- URL：`github.com/owner/repo/issues/123`、`/pull/456`、`/commit/abc123`
- 短引用：`#123`、`owner/repo#456`
- 关键词+数字：`issue 123`、`pr 456`、`pull request 456`

## 步骤

### 1) 识别资源并获取上下文

| 模式 | 类型 | gh 命令 |
|------|------|---------|
| `#123` 或 `/issues/123` | Issue | `gh issue view 123` |
| `#456` 或 `/pull/456` | PR | `gh pr view 456` |
| `/commit/abc123` 或 `abc123` | Commit | `git show abc123` 或 `gh api repos/{owner}/{repo}/commits/abc123` |
| `/releases/tag/v1.0` | Release | `gh release view v1.0` |
| `/actions/runs/123` | Workflow Run | `gh run view 123` |

- 优先使用 `--json` 获取结构化信息并输出摘要
- 仅出现 `#123` 且无法推断仓库时，先询问 owner/repo

### 2) 关联操作（仅 Git 操作场景）
- commit/PR 场景询问关联方式：`Fixes #N` / `Refs #N` / 跳过
- 可根据 issue 标题推断 commit type

### 3) 执行 GitHub 操作

| 操作 | gh 命令 |
|------|---------|
| 创建 PR | `gh pr create` |
| 添加评论 | `gh issue comment N --body "..."` |
| 关闭 issue | `gh issue close N` |
| 合并 PR | `gh pr merge N` |
| 添加标签 | `gh issue edit N --add-label "..."` |
| 查看 workflow 日志 | `gh run view N --log-failed` |
| 重新运行 workflow | `gh run rerun N` |

## 错误处理
- `gh` 未安装：提示安装并停止
- 未认证：提示 `gh auth login` 并停止
- 资源不存在：提示检查引用并说明已尝试命令
- 网络错误：重试一次，仍失败则提示用户
- 引用歧义（如 `#123` 可能是 issue 或 PR）：先询问资源类型

## 退出标准
- GitHub 资源信息已获取并格式化展示
- 用户请求操作已执行，或已明确说明未执行原因（权限/条件不满足）
