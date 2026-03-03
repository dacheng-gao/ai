---
name: github
description: GitHub 集成。识别 GitHub 链接、使用 gh CLI 获取上下文、关联到 commit、执行 GitHub 操作。自动触发。
argument-hint: "<url | #issue | PR N>"
---

# GitHub 集成

使用 `gh` CLI 识别 GitHub 资源、获取上下文并执行操作。

示例命令中的 `<gh_cmd>` 默认是 `gh`；当 `gh` 出现网络失败时，切换为 `proxy-gh`。

## 命令选择策略
1. 默认 `gh` 执行命令。
2. 若 `gh` 报网络错误（如 `timeout`、`TLS handshake timeout`、`connection reset`、`Temporary failure in name resolution`），且 `command -v proxy-gh` 可用，则使用同一参数改为 `proxy-gh` 重试一次。
3. 仅网络错误触发回退；鉴权、权限、资源不存在等错误不切换命令，按原错误处理流程执行。
4. 若 `proxy-gh` 不可用或重试后仍失败，输出已尝试命令与错误摘要并停止。

## 自动触发
- URL：`github.com/owner/repo/issues/123`、`/pull/456`、`/commit/abc123`
- 短引用：`#123`、`owner/repo#456`
- 关键词+数字：`issue 123`、`pr 456`、`pull request 456`

## 步骤

### 1) 识别资源并获取上下文

| 模式 | 类型 | `<gh_cmd>` 命令 |
|------|------|---------|
| `#123` 或 `/issues/123` | Issue | `<gh_cmd> issue view 123` |
| `#456` 或 `/pull/456` | PR | `<gh_cmd> pr view 456` |
| `/commit/abc123` 或 `abc123` | Commit | `git show abc123` 或 `<gh_cmd> api repos/{owner}/{repo}/commits/abc123` |
| `/releases/tag/v1.0` | Release | `<gh_cmd> release view v1.0` |
| `/actions/runs/123` | Workflow Run | `<gh_cmd> run view 123` |

- 优先使用 `--json` 获取结构化信息并输出摘要
- 仅出现 `#123` 且无法推断仓库时，先询问 owner/repo

### 2) 关联操作（仅 Git 操作场景）
- commit/PR 场景询问关联方式：`Fixes #N` / `Refs #N` / 跳过
- 可根据 issue 标题推断 commit type

### 3) 执行 GitHub 操作

| 操作 | `<gh_cmd>` 命令 |
|------|---------|
| 创建 PR | `<gh_cmd> pr create` |
| 添加评论 | `<gh_cmd> issue comment N --body "..."` |
| 关闭 issue | `<gh_cmd> issue close N` |
| 合并 PR | `<gh_cmd> pr merge N` |
| 添加标签 | `<gh_cmd> issue edit N --add-label "..."` |
| 查看 workflow 日志 | `<gh_cmd> run view N --log-failed` |
| 重新运行 workflow | `<gh_cmd> run rerun N` |

## 错误处理
- `gh` 未安装：提示安装并停止
- 未认证：提示 `gh auth login` 并停止
- 资源不存在：提示检查引用并说明已尝试命令
- 网络错误：按“命令选择策略”切换到 `proxy-gh` 重试一次，仍失败则提示用户检查网络或代理配置
- 引用歧义（如 `#123` 可能是 issue 或 PR）：先询问资源类型

## 退出标准
- GitHub 资源信息已获取并格式化展示
- 用户请求操作已执行，或已明确说明未执行原因（权限/条件不满足）
