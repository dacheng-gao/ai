---
name: git
description: Use when inspecting or changing local Git state, including diffs, staging, commits, restores, reverts, and merge, rebase, or cherry-pick conflict resolution.
---

# Git

Operate on the exact local Git scope the user requested.

## Safety

- Start with `git status --short --branch` and inspect the relevant
  staged or unstaged diff before a write.
- Treat staged, unstaged, and untracked content as separate ownership scopes.
  If the user says staged changes only, derive every conclusion and commit from
  the index only.
- Stage explicit paths or requested hunks. Do not use `git add .` when
  unrelated changes could exist.
- Never discard work, rewrite history, abort an operation, or run destructive
  recovery without explicit authorization.
- Create a commit only when the user explicitly requests it. A clear commit
  request is sufficient authorization; ask again only when the scope or message
  materially remains ambiguous.
- Do not add AI attribution or unrequested trailers.

## Operations

- Inspect with `git diff`, `git diff --staged`, and
  `git show` as appropriate.
- Before committing, verify the staged diff is non-empty, coherent, and free of
  whitespace errors. Derive a concise message from the staged content and the
  repository's convention.
- Before restore or revert, state the exact path or commit and which state will
  change. Preserve unrelated index and worktree content.
- During conflict resolution, identify the active Git operation, inspect every
  unresolved file, resolve semantics rather than choosing a side blindly, and
  continue only when requested or already authorized.

After a write, re-read status and the relevant diff or commit. Report the command
result, affected scope, and any preserved dirty state or unresolved conflict.
