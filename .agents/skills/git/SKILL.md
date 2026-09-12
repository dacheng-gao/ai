---
name: git
description: Inspect and manage local Git repositories, including worktree and index state, commits, branches, remotes, worktrees, history, synchronization, and merge, rebase, or cherry-pick conflicts. Use github instead for GitHub issues, comments, pull requests, checks, releases, or repository settings.
---

# Git

Manage the exact local repository state and ownership scope requested by the user. Keep GitHub-hosted collaboration in the `github` skill.

## Establish State

Before a write, identify the repository and inspect enough state to predict its effect:

```bash
git status --short --branch
git diff
git diff --staged
```

Also inspect upstreams, worktrees, unmerged entries, or the active operation when relevant. Treat staged, unstaged, untracked, ignored, stashed, and other-worktree content as separate scopes. Unexplained content is user-owned.

## Authorization Boundary

- Read-only inspection may proceed when it serves the requested task.
- Create a commit only when the user explicitly requests a commit. Stage only explicit paths or hunks within that request.
- A request to merge, rebase, cherry-pick, revert, synchronize, or create/switch a branch authorizes the ordinary local writes necessary for that named operation, but not unrelated cleanup or history rewriting.
- Require explicit authorization for discard, hard reset, clean, abort, branch or tag deletion, force push, published-history rewrite, reflog expiry, or other difficult-to-recover actions. Resolve the exact target first.
- Never hide a dirty tree with an automatic stash unless the user authorized that behavior. Never use `git add .` when unrelated changes may exist.
- Do not add AI attribution, unrequested trailers, or bypass hooks unless requested.

## Route The Operation

- For diffs, staged-only commits, amend decisions, commit ranges, and history diagnosis, read [references/commits-and-history.md](references/commits-and-history.md).
- For branch creation, tracking, synchronization, remotes, worktrees, tags, push, and deletion, read [references/branches-and-remotes.md](references/branches-and-remotes.md).
- For merge, rebase, cherry-pick, revert, apply, or stash conflicts, read [references/conflicts-and-recovery.md](references/conflicts-and-recovery.md).

Use more than one reference only when the task genuinely crosses those modes.

## Verify And Report

After a write, re-read `git status --short --branch` and verify the object that changed with the relevant diff, log, ref, or worktree command. Report:

- the repository and operation;
- changed refs, commits, index/worktree paths, or remaining conflicts;
- checks run and their outcome;
- preserved dirty state and any residual risk.

Do not claim a remote result from local state alone. For GitHub remote state, use the `github` skill and verify through `gh`.
