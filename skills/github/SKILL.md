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

### 1. 识别资源类型

从用户输入中提取 GitHub 引用，判断类型：

| 模式 | 类型 | gh 命令 |
|------|------|---------|
| `#123` 或 `/issues/123` | Issue | `gh issue view 123` |
| `#456` 或 `/pull/456` | PR | `gh pr view 456` |
| `/commit/abc123` 或 `abc123` | Commit | `gh commit view abc123` |
| `/releases/tag/v1.0` | Release | `gh release view v1.0` |

### 2. 获取上下文

```bash
# Issue/PR 详情
gh issue view 123 --json title,state,labels,url,body
gh pr view 456 --json title,state,labels,url,body

# 仓库信息
gh repo view --json name,owner,defaultBranchRef
```

### 3. 显示上下文

输出格式化的 GitHub 信息块：

```
📌 GitHub Context:
Issue #123: Login fails on Safari
State: open | Labels: bug, priority-high
URL: https://github.com/owner/repo/issues/123
```

### 4. 关联操作（仅在 Git 操作时）

当用户在 commit/PR 场景时：

1. 检测到 GitHub 引用后，询问关联方式：
   - `Fixes #123` - 自动关闭 issue
   - `Refs #123` - 仅引用
   - `Closes #123` - 同 Fixes
   - 跳过

2. 根据 issue 标题推断 commit type：
   - 包含 "bug", "fix", "error" → `fix`
   - 包含 "feat", "add", "new" → `feat`
   - 包含 "doc", "readme" → `docs`
   - 包含 "refactor", "clean", "optimize" → `refactor`

### 5. 执行 GitHub 操作

根据用户请求执行相应操作：

| 操作 | gh 命令 |
|------|---------|
| 创建 PR | `gh pr create --title "..." --body "..."` |
| 添加评论 | `gh issue comment 123 --body "..."` |
| 关闭 issue | `gh issue close 123` |
| 合并 PR | `gh pr merge 456` |
| 添加标签 | `gh issue edit 123 --add-label "bug"` |

## 错误处理

- `gh` 未安装：提示用户安装 `gh` CLI
- 未认证：提示运行 `gh auth login`
- 资源不存在：提示检查引用编号或 URL
- 网络错误：重试一次后提示用户检查网络

## 示例交互

**用户:** "Fix the login bug in #123"

**AI:**
```
📌 GitHub Context:
Issue #123: Login fails on Safari
State: open | Labels: bug, priority-high
URL: https://github.com/owner/repo/issues/123

检测到这是 bug 修复。是否将此 issue 关联到 commit？
1) Fixes #123 (合并后自动关闭)
2) Refs #123 (仅引用)
3) 跳过关联
```
