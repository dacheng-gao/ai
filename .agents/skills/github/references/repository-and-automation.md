# Repository And Automation

Read this reference for hosted branch state, default branch, protection and rulesets, workflow runs, releases, or repository metadata/settings.

## Hosted Branches And Rules

Use GitHub API data for the current hosted ref and rules; a local `origin/*` ref may be stale. Before creating, renaming, or deleting a hosted branch, resolve its exact SHA, default-branch status, open PRs, protection/rulesets, and release or deployment dependencies.

Branch protection and repository rulesets can overlap. Inspect both effective constraints and bypass permissions before proposing a change. Editing rules, default branch, visibility, archive state, collaborators, webhooks, secrets, variables, environments, or security settings requires explicit scope and post-write verification.

## Workflow Runs And Checks

For failures, identify workflow, run attempt, event, head SHA, failed job, and relevant log excerpt before concluding or rerunning. A rerun is a remote write and may consume resources or redeploy; require explicit authorization and verify the new attempt rather than the old run.

Distinguish pending, skipped, neutral, cancelled, timed out, infrastructure failure, and test failure. A green workflow unrelated to the target SHA or required check set does not prove a PR gate.

## Releases And Tags

Treat tag creation, release creation, asset upload, draft publication, prerelease status, and release deletion as separate effects. Before publishing, verify repository, tag/target commit, title/body, assets, draft/prerelease flags, and existing releases. Afterward, re-read the release and report its URL and published state.

Local tag operations belong to the `git` skill. Verify both local and hosted refs when a workflow changes both.

## API Fallback

Prefer stable high-level `gh` commands. When using `gh api`, inspect current CLI help and the relevant API schema, use explicit `--method`, pass typed fields correctly, paginate collections when completeness matters, and avoid printing sensitive response fields. For GraphQL mutations, resolve node IDs from the target repository and re-query the mutated object.
