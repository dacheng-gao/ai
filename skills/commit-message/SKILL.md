---
name: commit-message
description: Use when you need a Conventional Commits message from staged git changes or a pasted diff - guides type/scope selection and subject/body/footer formatting for a compliant commit message
---

# Commit Message Generator

Generate high-quality git commit messages following [Conventional Commits](https://www.conventionalcommits.org/).
Core principle: capture the primary change and express it in the standard format.

> **Language Rule:** Commit messages MUST be in English (per global language rules).

---

## When to Use

Use when:
- You need a Conventional Commits message from staged changes or a pasted diff
- You want help selecting type/scope or writing a clear subject/body/footer
- The diff is large and needs a concise primary intent

Do not use when:
- There is no diff available and the user refuses to provide it
- You are asked for a non-Conventional-Commits format

---

## Step 1: Obtain Staged Diff

Run:
```bash
GIT_PAGER=cat git diff --staged
```

**Handle edge cases:**
- **Empty output** → Respond: "No staged changes. Stage files with `git add` or paste the diff."
- **Command fails** → Ask user to paste the staged diff manually.

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

### Quick Reference

#### Commit Types

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

#### Format Rules

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

### Selecting Scope

Scope should be a **noun** describing the affected area:
- Module name: `auth`, `api`, `db`
- Component: `button`, `header`, `modal`
- Feature: `login`, `payment`, `notifications`

Skip scope if changes are too broad or span multiple areas.

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
Exception: if there is no diff, request the staged diff instead of outputting a message.

```
<type>[(scope)]: <subject>

[body]

[footer]
```

---

## Common Mistakes

- Outputting explanations instead of a code block
- Using vague verbs like "update" or past tense
- Forcing a scope when changes span multiple areas
- Omitting `BREAKING CHANGE:` when behavior breaks

---

## Rationalizations vs Reality

| Excuse | Reality |
| --- | --- |
| "No staged changes, just guess" | No diff = no evidence. Ask for staged diff or pasted changes. |
| "Any wording is fine" | Conventional Commits formatting matters for tooling and changelogs. |
| "Scope is always required" | Skip scope when changes span multiple areas. |

---

## Red Flags - STOP

- No staged diff or pasted changes provided
- Output includes explanation instead of a code block
- Subject is past tense or ends with a period

---

## Example

```
fix(checkout): prevent duplicate order submission

Race condition allowed double-click to create duplicate orders.
Add idempotency key validation before processing.

Fixes #1234
```
