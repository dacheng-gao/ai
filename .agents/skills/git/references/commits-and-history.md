# Commits And History

Read this reference for commit inspection or creation, staged-only work, amendments, comparisons, blame, bisect, or history diagnosis.

## Inspect The Correct Snapshot

- Working tree versus index: `git diff -- <paths>`
- Index versus `HEAD`: `git diff --staged -- <paths>`
- Commit contents: `git show --stat --oneline <commit>` and `git show --format=fuller <commit>`
- Branch series: determine the merge base, then inspect `git log` and `git diff <base>...<head>`.
- Reworked series: use `git range-diff <old-base>..<old-head> <new-base>..<new-head>` when patch identity matters.

Do not infer staged content from the working-tree diff. Do not infer a PR-sized series from only its tip commit.

## Create A Commit

1. Confirm the user explicitly requested a commit and resolve its ownership scope.
2. Inspect status and both diffs. If the request is staged-only, derive scope exclusively from `git diff --staged` and do not stage anything else.
3. Stage only requested paths or hunks. Re-check the staged diff and `git diff --staged --check`.
4. Derive the message from the actual index and the repository's recent convention. Preserve requested wording.
5. Commit without bypassing hooks. If a hook changes files, inspect the new state before retrying; do not silently expand the commit.
6. Verify the created object with `git show --stat --oneline HEAD`, inspect its paths when needed, and prove whether the index is empty.

An empty index is a blocker for an ordinary commit, not permission to use `--allow-empty`. A failed commit does not imply nothing changed; re-read status.

## Amend And Rewrite

Amend changes the current commit object and may rewrite published history. Confirm that amend, its content scope, and the intended message behavior are authorized. Preserve author metadata unless the user asks to change it. Afterward, compare the old and new object when the old ID is available.

Interactive rebase, filter operations, and commit splitting require an explicit range and desired transformation. Establish whether commits are published and identify dependent branches or worktrees before rewriting.

## Diagnose History

Use `git log`, `git show`, `git blame`, `git merge-base`, `git cherry`, and `git bisect` as evidence, not as substitutes for reproducing behavior. For bisect, define a deterministic good/bad test and record skipped or untestable commits. Do not leave a bisect session active unintentionally.
