---
name: github
description: Inspect and manage GitHub-hosted repositories through gh, including issues and comments, pull requests and reviews, checks and workflow runs, hosted branches and rules, releases, and repository metadata. Use git instead for local worktree, index, commit, branch, remote-tracking, or conflict state.
---

# GitHub

Use GitHub as the authority for hosted collaboration state. Keep local repository mutations in the `git` skill.

## Use The CLI As The Authority

Before declaring an operation unsupported, inspect the installed CLI: run `gh <command> --help` (and, when needed, `gh help <topic>`), then follow the flags and examples shown there. `gh` capabilities vary by version and extension; do not rely on memory or on GitHub web UI behavior. Prefer a documented high-level command over `gh api`, and use `gh api` only after checking its help and the relevant endpoint requirements.

Comments can include local image or video attachments. For issue or pull-request comments, use `gh issue comment` or `gh pr comment` with repeated `--attach <file>[#alt text]`; verify the command's current help for limits and syntax. Preserve or add Markdown references as required by the command, and report upload failures separately from comment failures.

## Resolve Context

Resolve the host, `owner/repo`, resource number or URL, and authenticated account before relying on remote data. Prefer an explicit URL or `-R owner/repo`; use the current remote only when it is unambiguous. When authorization or identity matters, inspect `gh auth status` without exposing credentials.

Prefer `--json` with only the required fields and `--jq` for stable facts. Use `gh api` when the high-level command does not expose a required field or mutation, and verify endpoint identity before writing.

## Authorization Boundary

- Read remote state directly when it serves the user's request.
- Create, edit, comment, review, close, reopen, label, assign, transfer, lock, rerun, merge, publish, delete, or change repository settings only when that remote mutation is explicit in the request.
- Treat approval, change requests, merge, admin bypass, release publication, ruleset changes, branch deletion, and workflow reruns as distinct effects. Authorization for one does not imply another.
- Preserve the user's wording. For multiline or shell-sensitive Markdown, use `--body-file` or standard input rather than interpolating it into a shell command.
- Before a high-impact write, re-read target identity, current state, permissions, prerequisites, and the expected resulting effect.

## Route The Resource

- For issues, issue comments, labels, assignments, state changes, and linked development branches, read [references/issues-and-comments.md](references/issues-and-comments.md).
- For PR metadata, diffs, conversation comments, reviews, inline review threads, checks, updates, and merges, read [references/pull-requests-and-reviews.md](references/pull-requests-and-reviews.md).
- For hosted branches, rulesets and protection, workflow runs, releases, and repository settings, read [references/repository-and-automation.md](references/repository-and-automation.md).

Use more than one reference only when the request crosses those resources. When a workflow also changes local commits, branches, worktrees, or conflicts, load the `git` skill for that portion and keep the two evidence surfaces separate.

## Verify And Report

After a remote write, fetch the resource again and verify the intended field, comment, review, check, ref, or release. Report the canonical URL, exact repository/resource, observed result, and any permission, mergeability, check, queue, or eventual-consistency limitation.

Do not infer GitHub state from a local remote-tracking ref, and do not infer local state from GitHub metadata.
