# Pull Requests And Reviews

Read this reference for PR inspection, creation or editing, review comments, checks, head updates, readiness, closing, reverting, or merging.

## Inspect Before Deciding

Resolve the exact PR, then gather only the fields needed from `gh pr view --json`, commonly:

- repository, number, URL, state, draft status, author;
- base and head ref names and object IDs;
- mergeability and merge-state status;
- review decision, requests, latest reviews, and conversations;
- required/status checks, commits, files, and changed-line totals.

Inspect the actual patch with `gh pr diff` or authoritative commit objects. PR metadata alone is not code-review evidence. Check `gh pr checks --required` when required checks matter; exit code 8 means pending, not failure.

## Keep Comment Types Distinct

- `gh pr comment` creates an issue-style conversation comment.
- `gh pr review --comment`, `--approve`, or `--request-changes` submits a review state with an optional summary.
- An inline review comment is attached to a file/line/commit and may belong to a review thread. Use the API when necessary, preserving the correct commit and side/line coordinates.
- Resolving a review thread is a separate mutation from replying, editing code, or submitting a review.

Read existing reviews and threads before responding. Do not represent a conversation comment as approval or claim that code changes resolve a thread until the relevant diff and thread state prove it.

## Create Or Update A PR

Before creation, verify base/head repository and branches, the commit range, title/body, draft state, and whether a PR already exists. Local commits and pushes use the `git` skill. After creation, re-read the PR and return its canonical URL.

`gh pr update-branch` changes the hosted head through merge or rebase. Confirm the strategy and current head OID; use the `git` skill instead when conflicts or local control are required.

## Merge Safely

Merging requires explicit authorization for the exact PR. Immediately before merge:

1. Re-read repository, number, base/head refs, and head OID.
2. Verify draft state, review decision, mergeability, required checks, and repository rules or merge queue behavior.
3. Confirm merge method, commit message behavior, and whether branch deletion is desired.
4. Use `--match-head-commit <sha>` when supported to prevent merging an unreviewed new head.

Admin bypass, auto-merge, merge-queue enrollment, and local/remote branch deletion are separate effects. Afterward, verify `mergedAt`, `mergedBy`, merge commit or queue state, and branch existence as applicable. A successful command that enabled auto-merge is not proof the PR has already merged.
