---
name: github
description: Use when reading or changing GitHub issues, pull requests, workflow runs, releases, repository metadata, or remote review context through the GitHub CLI.
---

# GitHub

Use `gh` for GitHub state and keep remote actions within the user's
requested repository and resource.

## Scope

- Resolve the repository and resource from an explicit URL, `owner/repo`,
  number, or the current remote. Do not guess when multiple targets are plausible.
- Use `gh auth status` when authentication matters and prefer structured
  `--json` output for facts.
- Keep local Git operations outside this skill. Use the `git` skill when
  index, worktree, branch, or local history state must change.
- Read operations can proceed directly. Create, edit, close, merge, rerun,
  publish, or delete only when that mutation is explicit in the request.
- Before a high-impact action such as merge, release publication, or deletion,
  verify target, current state, prerequisites, and resulting effect.

## Work

1. Resolve the exact repository and issue, pull request, run, release, commit, or
   metadata query.
2. Fetch only fields and logs needed for the decision. Prefer direct GitHub data
   over copied summaries.
3. For writes, preserve the user's wording and scope, then re-read the remote
   resource after the command.
4. For workflow failures, identify the failed job and relevant log excerpt
   before proposing or requesting a rerun.

Report the resource, action or finding, command result, and canonical GitHub URL.
If authentication, permissions, mergeability, required checks, or remote state
blocks the request, state the exact blocker without changing a different target.
