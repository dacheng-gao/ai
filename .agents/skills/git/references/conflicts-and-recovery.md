# Conflicts And Recovery

Read this reference whenever Git reports unmerged entries or an operation such as merge, rebase, cherry-pick, revert, apply, or stash pop is incomplete.

## Identify The Operation

Start with:

```bash
git status --short --branch
git status
git ls-files -u
```

Use the repository's operation state and sequencer metadata to distinguish merge, rebase, cherry-pick, revert, am/apply, bisect, or an ordinary unmerged index. Do not choose a continuation or abort command from conflict markers alone.

## Resolve Semantics

For each unmerged path:

1. Inspect all stages with `git ls-files -u` and `git show :1:path`, `:2:path`, and `:3:path` when useful.
2. Understand the intent of both changes and the common base. During rebase, the meaning of `ours` and `theirs` differs from the intuitive branch labels; do not use either side blindly.
3. Resolve the combined behavior, including rename/delete, binary, submodule, mode, and modify/delete cases.
4. Remove conflict markers, run focused checks, then stage only the resolved path.
5. Re-run `git diff --check`, inspect `git diff --staged`, and confirm `git ls-files -u` is empty before continuing.

Do not overwrite a user's pre-existing edits while resolving an operation. If ownership cannot be separated safely, stop and ask about that path.

## Continue, Skip, Or Abort

Continue only when the original operation was requested or its continuation is explicitly authorized. A conflict resolution does not itself authorize dropping a commit, accepting an empty result, changing the todo list, or bypassing hooks.

- `--skip` discards the current patch's effect and needs explicit intent.
- `--abort` or destructive recovery rewinds operation state and needs explicit authorization after identifying what will be restored or lost.
- If a commit becomes empty, determine whether its changes are already present or were accidentally removed before choosing drop or keep.
- After continuation, repeat conflict inspection because later commits may conflict independently.

At completion, verify the resulting topology and diff against the intended base, run the relevant tests, and report any stash entries, backup refs, rerere state, or untracked files left behind.
