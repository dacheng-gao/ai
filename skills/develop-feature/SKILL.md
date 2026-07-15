---
name: develop-feature
description: Use when implementing a repository feature, integration, API or schema change, or other intentional behavior addition after the desired outcome is clear enough to build.
---

# Develop Feature

Deliver the smallest coherent behavior that satisfies the approved outcome.

## Boundaries

- Confirm the user-visible result, scope, non-goals, and acceptance evidence.
- If important requirements or design trade-offs remain unresolved, use
  `superpowers:brainstorming` before implementation.
- Preserve existing contracts unless a change is explicit. For APIs, schemas,
  data, configuration, or deployment, account for compatibility, rollout, and
  recovery.
- Do not bundle speculative infrastructure, broad refactors, or unrelated fixes.

## Delivery

1. Inspect the relevant implementation, tests, conventions, and current
   worktree.
2. Define a narrow end-to-end slice and the evidence that will prove it.
3. Use `superpowers:test-driven-development` for production behavior:
   establish a failing check, implement the minimum change, then keep it green.
4. Integrate documentation, migration, observability, or error handling only
   where the feature requires them.
5. Use `superpowers:verification-before-completion` before claiming the
   outcome.

Report the resulting behavior, key files, verification evidence, and any
unimplemented acceptance item or rollout risk. Do not equate compilation with a
working feature when runtime or user-facing evidence is feasible.
