---
name: fix-bug
description: Use when investigating and repairing a regression, crash, failing test, incorrect output, integration failure, or performance problem in a repository.
---

# Fix Bug

Restore the intended behavior by fixing the demonstrated root cause.

**REQUIRED SUB-SKILL:** Use `superpowers:systematic-debugging` before
proposing a code change.

## Invariants

- Start from the exact symptom, failing command, request, log, or contract.
- Reproduce the failure or collect equivalent runtime evidence. If reproduction
  is blocked, say what evidence is missing instead of guessing.
- Trace where observed behavior first diverges from expected behavior. Test one
  causal hypothesis at a time.
- Do not hide the defect with broad exception handling, fallback data, retries,
  disabled validation, or weakened tests.
- Keep the fix at the root-cause boundary and preserve unrelated behavior.

## Repair

1. Record the failing baseline and affected scope.
2. For a production change, use
   `superpowers:test-driven-development` to add a regression check that
   fails for the demonstrated defect.
3. Apply the smallest causal fix and verify the regression check turns green.
4. Re-run the original symptom plus related checks. Runtime, integration, or
   performance symptoms need corresponding evidence when feasible.
5. Use `superpowers:verification-before-completion` before reporting the
   bug as fixed.

Report the root cause, changed behavior, RED/GREEN evidence, original-symptom
verification, and remaining environmental or coverage limits.
