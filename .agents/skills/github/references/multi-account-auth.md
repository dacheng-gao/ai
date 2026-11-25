# Multi-Account Authentication

Read this reference when multiple `gh` accounts are logged in on the host, when the target repository belongs to a non-active account, or when a `gh` command fails with a permission/visibility error caused by an account mismatch.

## Keep The Active Account Stable

Treat the user's active `gh` account (typically their primary personal account) as global host state. Do not run `gh auth switch` to work around a repository account mismatch—switching mutates global state and races with concurrent terminals or agent sessions.

Instead, inject a per-command token for the resolved account via `GH_TOKEN` (or `GH_ENTERPRISE_TOKEN` for GitHub Enterprise Server), which overrides the active account for that single command only.

## Resolve The Target Account

Resolve the intended GitHub login in this order before invoking `gh`:

1. **Repository Git config (authoritative)**: Run `git config --get github.user` inside the target repository. Git automatically applies global defaults, `includeIf` directory profiles, and `--local` repo overrides.
2. **Exact owner match (fallback)**: If `github.user` is unset and the repository owner exactly matches an authenticated login listed in `gh auth status`, use that login.
3. **Ask when ambiguous**: If `github.user` is unset and the owner is an organization or cannot be mapped unambiguously, inspect `gh auth status` (account names only) and ask the user which account to use. Never probe accounts in a loop.

Check whether the resolved account is already the active account for the target host. If it is, run `gh` normally without fetching a token.

## Per-Command Token Injection

When the resolved account differs from the active account:

```bash
gh_user="$(git config --get github.user)"
gh_token="$(gh auth token --user "$gh_user")" && [ -n "$gh_token" ] && GH_TOKEN="$gh_token" gh <subcommand> ...
```

- Always check both the exit status of `gh auth token` and `[ -n "$gh_token" ]` before invoking `gh`; an empty `GH_TOKEN` can silently fall back or fail with a misleading error.
- For GitHub Enterprise Server (hosts other than `github.com`, `*.ghe.com`, and `github.localhost`), pass `--hostname "$gh_host"` to `gh auth token` and set `GH_ENTERPRISE_TOKEN="$gh_token"` instead of `GH_TOKEN`.
- For non-repo commands targeting `-R owner/repo`, remember that `git config --get github.user` outside a repo returns only the global default; pass the explicit user when targeting another account's repository.

## Credential And Safety Rules

- Never print, echo, log, trace (`set -x`), or return `$gh_token` / `$GH_TOKEN`.
- Never `export GH_TOKEN` across unrelated commands; keep it prefixed to the single `gh` invocation.
- Never pass tokens via command-line arguments (such as `-H "Authorization: Bearer ..."`), which expose secrets in process listings.
- Do not combine `GH_TOKEN` with `gh auth login`, `gh auth logout`, or `gh auth switch`.
- If a command still fails with a scope or permission error under the intended account, report the exact account and error rather than silently trying another account.
