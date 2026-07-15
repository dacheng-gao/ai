---
name: refactor
description: Use when improving internal structure, dependencies, readability, maintainability, or performance without intentionally changing externally observable behavior.
---

# Refactor

Improve the implementation while preserving an explicit behavior boundary.

## Boundary

- Define what must stay unchanged: public interfaces, inputs and outputs, error
  semantics, side effects, ordering, persistence, compatibility, and relevant
  resource characteristics.
- Establish a baseline from tests, callers, contracts, runtime evidence, or a
  focused characterization check.
- If current behavior is defective, use `fix-bug`. If the desired
  behavior changes, use `develop-feature`.
- Do not mix unrelated cleanup, new features, migrations, or naming campaigns
  into the refactor.

## Work

1. Identify the concrete structural cost and the smallest useful boundary.
2. Use `superpowers:test-driven-development` when production behavior
   could be affected; confirm the protection fails when the behavior is broken.
3. Change one structural concern at a time and keep the protection green.
4. Re-check callers, contracts, errors, side effects, and performance or resource
   evidence that belongs to the stated boundary.
5. Use `superpowers:verification-before-completion` before reporting
   behavioral equivalence.

Report the structural improvement, preserved behavior, evidence used before and
after, and any boundary that could not be verified. Do not claim “no behavior
change” from code inspection alone when executable evidence is available.
