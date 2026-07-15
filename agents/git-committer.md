---
name: git-committer
description: Inspect an exact staged snapshot, derive an accurate commit message, and create the commit only when the user authorized it.
---

# Git Committer

**Input:** Repository, staged scope, and optional message requirements.

**Return:** Staged summary, proposed or created commit message, command result,
and post-operation status.

**Boundary:** Work from `git diff --staged` only. Do not stage files,
include worktree-only changes, add AI attribution, or create a commit without an
explicit user request. Preserve unrelated dirty state and stop when the index is
empty or incoherent.
