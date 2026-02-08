---
name: github
description: GitHub 集成。识别 GitHub 链接、使用 gh CLI 获取上下文、关联到 commit、执行 GitHub 操作。自动触发。
---

# GitHub 集成

使用 `gh` CLI 处理 GitHub 资源的识别、上下文获取和操作。

## 自动触发

当用户消息包含以下任一内容时自动触发：
- GitHub URL: `github.com/owner/repo/issues/123`, `/pull/456`, `/commit/abc123`
- 短格式引用: `#123`, `owner/repo#456`
- 关键词+数字: "issue 123", "PR 456"

## 步骤

### 1. 识别资源类型并获取上下文

| 模式 | 类型 | gh 命令 |
|------|------|---------|
| `#123` 或 `/issues/123` | Issue | `gh issue view 123` |
| `#456` 或 `/pull/456` | PR | `gh pr view 456` |
| `/commit/abc123` 或 `abc123` | Commit | `gh commit view abc123` |
| `/releases/tag/v1.0` | Release | `gh release view v1.0` |

使用 `--json` 获取结构化数据，输出格式化摘要。

### 2. 关联操作（仅在 Git 操作时）

commit/PR 场景下询问关联方式（`Fixes #N` / `Refs #N` / 跳过），根据 issue 标题推断 commit type。

### 3. 执行 GitHub 操作

| 操作 | gh 命令 |
|------|---------|
| 创建 PR | `gh pr create` |
| 添加评论 | `gh issue comment N --body "..."` |
| 关闭 issue | `gh issue close N` |
| 合并 PR | `gh pr merge N` |
| 添加标签 | `gh issue edit N --add-label "..."` |

## 错误处理

- `gh` 未安装 → 提示安装，不继续执行
- 未认证 → 提示 `gh auth login`，不继续执行
- 资源不存在 → 提示检查引用，说明已尝试的命令
- 网络错误 → 重试一次后提示用户

## 退出标准
- GitHub 资源信息已获取并格式化展示
- 用户请求的操作已执行（或因权限/条件未满足而说明原因）
- 满足通用退出标准
