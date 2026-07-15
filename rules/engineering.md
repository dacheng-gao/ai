# Engineering Baseline

Apply these defaults only when more specific user or project instructions do not
override them.

## Scope And Safety

- Inspect relevant code, configuration, tests, documentation, and current
  worktree state before making consequential changes.
- Preserve unexplained changes and user-owned data. Never use destructive
  recovery or broad cleanup without explicit authorization.
- Keep changes local to the requested outcome. Reuse established patterns before
  adding abstractions, dependencies, or new conventions.
- Validate untrusted input and avoid exposing credentials or sensitive data.
  Treat production writes, permissions, migrations, and destructive operations
  as high risk.

## Execution

- Choose effort by consequence, uncertainty, and blast radius rather than a
  fixed file or line threshold.
- Execute clear, reversible work directly. Pause only for a material product
  decision, missing authority, destructive action, or ambiguity that would
  produce meaningfully different results.
- Diagnose failures from evidence and root cause. Do not hide errors or redefine
  success around what happened to work.
- Add comments, tests, documentation, and abstractions only when they reduce a
  real risk or maintenance cost.

## Verification

- Decide what evidence would prove the requested result, then run the strongest
  practical checks available for that scope.
- Match verification to risk: focused checks for local changes, broader checks
  for shared contracts, data, security, deployment, or user-visible workflows.
- Review the final diff for scope, correctness, accidental churn, and secrets.
- Never claim completion or passing checks without fresh evidence. Report
  unverified areas and residual risk explicitly.
