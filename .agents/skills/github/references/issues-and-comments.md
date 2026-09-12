# Issues And Comments

Read this reference for issue triage, issue creation or editing, comments, labels, assignments, milestones, state transitions, or linked development branches.

## Read The Full Decision Surface

Use `gh issue view <number-or-url> --json ...` for structured fields and request comments when discussion affects the decision. For lists, constrain repository, state, labels, assignee, author, or search terms rather than downloading unrelated issues.

Distinguish observed GitHub fields from conclusions inferred from prose. An open issue is not proof that work is unstarted; a closing keyword is not proof that a PR has merged.

## Write Deliberately

- For creation or edits, preserve the requested title/body and apply only specified metadata.
- For comments, distinguish creating a new comment from editing or deleting the authenticated user's last comment. Re-read the thread to verify authorship, placement, and body.
- Closing and commenting are separate mutations. Confirm the desired state reason when it matters.
- Transfer, delete, lock, pin, and project or milestone changes have wider coordination impact; require that specific effect.

Use `--body-file` or stdin for Markdown containing backticks, `$()`, quotes, or multiline code. Do not expose tokens or private data in command output or comment bodies.

For screenshots or videos, check `gh issue comment --help` at runtime and use one or more `--attach` flags (including `#alt text` for images). Do not claim attachments are unsupported based on memory. Verify the resulting comment and attachment links after a successful write.

## Linked Branches

`gh issue develop` changes GitHub linkage and may also create or check out a branch. Treat hosted branch creation/linkage under this skill; route local checkout, dirty-tree handling, and branch verification through the `git` skill. Verify both surfaces when both changed.

For sub-issues, blockers, projects, issue types, reactions, or fields absent from the high-level command, inspect the current `gh` help and use `gh api` with stable IDs. Do not guess GraphQL node IDs from issue numbers.
