---
name: writing-test-cases
description: Use when stable product requirements, a feature specification, or acceptance criteria need to become a prioritized test plan and traceable executable test cases.
---

# Write Test Cases

Turn agreed behavior into a focused verification model.

## Input Boundary

- Identify the authoritative requirement, scope, acceptance criteria, roles,
  dependencies, and environment assumptions.
- If an unresolved product decision can change expected behavior or coverage,
  mark the result as a draft and expose that gap instead of inventing an answer.
- Do not rewrite the PRD, implement automation, or expand product scope.

## Model

Derive coverage from risk and observable behavior:

- primary user workflows and state transitions;
- invalid input, failure handling, and recovery;
- boundaries and representative equivalence classes;
- permissions and role differences;
- compatibility, migration, concurrency, or regression paths when applicable.

Trace every test to a requirement or acceptance criterion. Avoid cases that only
repeat implementation details. Use `P0` for release-blocking behavior,
`P1` for important failures with a viable workaround or narrower reach,
and `P2` for lower-risk coverage.

## Test Case

For each case, state a stable ID, trace source, priority, preconditions, input or
action, and observable expected result. Keep one principal behavior per case;
share setup or parameterize equivalent variants rather than duplicating long
step lists.

Deliver the smallest release-relevant set first, followed by additional coverage
only when useful. Summarize requirement coverage, environment needs, excluded
areas, unresolved questions, and risks that still require exploratory,
non-functional, or runtime testing.
