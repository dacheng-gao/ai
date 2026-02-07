---
name: commit-message
description: 当需要基于已暂存的 git 变更或粘贴的 diff 生成 Conventional Commits 提交信息时使用。
---

# 提交信息生成器

## 概述

生成符合 [Conventional Commits](https://www.conventionalcommits.org/) 的提交信息。核心：抓住主要变更，用标准格式表达。

> **语言规则：** 提交信息必须为英文（遵循全局语言规则）。

### 使用场景

- 需要基于已暂存变更或粘贴的 diff 生成 Conventional Commits 信息
- 需要帮助选择 type/scope，或写清晰的 subject/body/footer
- diff 很大，需要提炼主要意图

### 不使用场景

- 没有 diff 且用户拒绝提供
- 被要求非 Conventional-Commits 格式

---

## 步骤 1：获取已暂存 diff

运行：
```bash
GIT_PAGER=cat git diff --staged
```

**处理边界情况：**
- **输出为空** → 回复："暂无已暂存的变更。请先使用 `git add` 暂存文件或手动粘贴 diff。"
- **命令失败** → 请用户手动粘贴已暂存 diff。

---

## 步骤 2：分析变更

识别：
1. **主要目的** — 变更的核心意图是什么？
2. **影响范围** — 主要影响哪个模块/组件/文件？
3. **破坏性变更** — 是否破坏现有 API 或行为？

### 大型 diff 处理（>300 行）

1. 按文件/模块总结变更
2. 聚焦主要目的
3. 若应拆分 → 建议："建议拆分为多个提交：[列表]"

---

## 步骤 3：生成提交信息

> 类型与格式规范见 `rules/git-workflow.md`。

### 选择 Scope

Scope 应为描述影响范围的**名词**：
- Module name: `auth`, `api`, `db`
- Component: `button`, `header`, `modal`
- Feature: `login`, `payment`, `notifications`

若变更过于广泛或跨多个区域，跳过 scope。

### 避免

- ❌ 含糊动词：`update`, `change`, `modify`（除非不可避免）
- ❌ 过去时：`added`, `fixed` → 用 `add`, `fix`
- ❌ 以冠词开头：`Add a feature` → `Add feature`

---

## 步骤 4：自检

输出前检查：
- [ ] Subject ≤72 characters
- [ ] Uses imperative mood ("add" not "added")
- [ ] Type matches the primary change
- [ ] No vague verbs unless essential
- [ ] Breaking changes noted in footer if applicable

---

## 输出格式

**只输出**代码块内的提交信息，不给 Git 命令或解释。
例外：如果没有 diff，请请求已暂存 diff，而不是输出提交信息。

```
<type>[(scope)]: <subject>

[body]

[footer]
```

---

## 常见错误

- 输出解释而不是代码块
- 使用含糊动词或过去时
- 变更跨多区域时强行加 scope
- 行为破坏时遗漏 `BREAKING CHANGE:`

---

## 借口 vs 事实

| 借口 | 事实 |
| --- | --- |
| “没有已暂存变更，随便猜” | 没有 diff 就没有证据。请求暂存 diff 或粘贴变更。 |
| “措辞随便” | Conventional Commits 格式影响工具与变更日志。 |
| “Scope 一定要有” | 跨多区域就跳过 scope。 |

---

## 红旗 - 立刻停止

- 未提供已暂存 diff 或粘贴的变更
- 输出包含解释而不是代码块
- Subject 为过去时或以句号结尾

---

## 示例

```
fix(checkout): prevent duplicate order submission

Race condition allowed double-click to create duplicate orders.
Add idempotency key validation before processing.

Fixes #1234
```
