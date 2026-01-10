---
name: commit-message
description: Generate git commit message from staged changes using Conventional Commits
triggers:
  - commit message
  - git message
  - write commit
  - generate commit
  - 提交信息
  - 生成 commit
  - 写 commit
---

# Commit Message Generator

Generate high-quality git commit messages following [Conventional Commits](https://www.conventionalcommits.org/).

> **Language Rule:** Commit messages MUST be in English (per global language rules).

---

## Step 1: Obtain Staged Diff

Run:
```bash
GIT_PAGER=cat git diff --staged
```

**Handle edge cases:**
- **Empty output** → Respond: "No staged changes. Stage files with `git add` or paste the diff."
- **Command fails** → Ask user to paste the staged diff manually.
- **Never stop** without generating a message or requesting the diff.

---

## Step 2: Analyze Changes

Identify:
1. **Primary purpose** — What is the main intent of this change?
2. **Affected scope** — Which module/component/file is primarily affected?
3. **Breaking changes** — Does this change break existing APIs or behavior?

### Large Diff Handling (>300 lines)

1. Summarize changes by file/module
2. Focus on the primary purpose
3. If changes should be split → Suggest: "Consider splitting into multiple commits: [list]"

---

## Step 3: Generate Message

### Commit Types

| Type | Use When |
|------|----------|
| `feat` | New feature for the user |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code restructure, no behavior change |
| `perf` | Performance improvement |
| `test` | Adding/fixing tests |
| `build` | Build system, dependencies |
| `ci` | CI/CD configuration |
| `chore` | Maintenance, tooling |
| `revert` | Reverting a previous commit |

### Selecting Scope

Scope should be a **noun** describing the affected area:
- Module name: `auth`, `api`, `db`
- Component: `button`, `header`, `modal`
- Feature: `login`, `payment`, `notifications`

Skip scope if changes are too broad or span multiple areas.

### Format Rules

```
<type>[(scope)]: <subject>

[body]

[footer]
```

| Element | Rule |
|---------|------|
| **Subject** | Imperative mood, ≤72 chars (aim ≤50), no period |
| **Body** | Explain *what* and *why* (not *how*), wrap at 72 chars, optional |
| **Footer** | `BREAKING CHANGE:`, `Fixes #123`, `Refs #456`, optional |

### Avoid

- ❌ Vague verbs: "update", "change", "modify" (unless unavoidable)
- ❌ Past tense: "added", "fixed" → Use "add", "fix"
- ❌ Articles at start: "Add a feature" → "Add feature"

---

## Step 4: Self-Verify

Before outputting, check:
- [ ] Subject ≤72 characters
- [ ] Uses imperative mood ("add" not "added")
- [ ] Type matches the primary change
- [ ] No vague verbs unless essential
- [ ] Breaking changes noted in footer if applicable

---

## Output Format

Output **only** the commit message in a code block. No Git commands, no explanation.

```
<type>[(scope)]: <subject>

[body]

[footer]
```

---

## Examples

### Simple Feature

```
feat(auth): add Google OAuth2 login
```

### Feature with Body

```
feat(api): add rate limiting to public endpoints

Implement token bucket algorithm with 100 req/min per IP.
Add X-RateLimit-* headers for client visibility.
```

### Bug Fix with Issue Reference

```
fix(checkout): prevent duplicate order submission

Race condition allowed double-click to create duplicate orders.
Add idempotency key validation before processing.

Fixes #1234
```

### Breaking Change

```
feat(config)!: migrate to YAML configuration format

BREAKING CHANGE: JSON configuration files are no longer supported.
Run `migrate-config --format yaml` before upgrading.
```

### Refactor

```
refactor(db): extract connection pooling to dedicated module

Improve testability by decoupling pool management from query execution.
No behavior changes.
```
