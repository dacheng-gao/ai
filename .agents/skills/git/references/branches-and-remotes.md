# Branches And Remotes

Read this reference for branch lifecycle, upstream tracking, fetch/pull/push, worktrees, tags, or remote configuration.

## Resolve Topology

Inspect the facts needed for the operation:

```bash
git branch --show-current
git branch -vv
git remote -v
git status --short --branch
git worktree list --porcelain
```

Use `git rev-list --left-right --count <upstream>...HEAD` for divergence. A remote-tracking ref is only as current as the last fetch. Use `git ls-remote` for a non-mutating remote check, or fetch when updating local remote-tracking refs is in scope.

## Create, Switch, And Track

- Resolve the base commit before creating a branch.
- Prefer `git switch` for branch switching and `git restore` for path restoration so intent is explicit.
- Before switching, check dirty paths, untracked collisions, submodules, and whether the target branch is already checked out in another worktree.
- Verify the new branch tip and upstream separately. Do not assume a same-named remote branch is the intended upstream.

## Synchronize

`git pull` combines fetch with merge or rebase and can obscure which step failed. When diagnosis or control matters, fetch first, inspect divergence, then choose fast-forward, merge, or rebase from repository policy and user intent.

- Prefer `--ff-only` when no merge or rewrite was authorized.
- Rebasing rewrites local commits; establish whether they are published.
- Pushing creates or changes remote refs. Verify destination remote, refspec, upstream behavior, and authentication before the write.
- If a rewritten branch must be pushed, require explicit force-push authorization and use `--force-with-lease` against a freshly verified expected remote tip. Never treat it as risk-free.

## Worktrees, Tags, And Deletion

Branch deletion can affect another worktree or discard commits not reachable elsewhere. Before deletion, inspect worktree occupancy, merge status, unique commits, and the exact local or remote target. Local and remote deletion are separate effects and require separate scope.

Before removing a worktree, inspect its status at that worktree path. Before moving or deleting a tag, determine whether it is published or used by a release. Verify all ref changes with `git show-ref`, `git branch -vv`, `git tag`, or `git ls-remote` as appropriate.

GitHub branch protection, rulesets, linked issue branches, and PR base/head metadata are hosted state; route those parts to the `github` skill.
