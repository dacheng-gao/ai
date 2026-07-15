---
name: reviewing-product-requirements
description: Use when turning a feature idea, issue, stakeholder note, or incomplete specification into a concise, testable product requirement with explicit scope and open decisions.
---

# Review Product Requirements

Produce the smallest requirement document that supports a product decision and
subsequent delivery.

## Model

- Separate the user or business problem from the proposed solution.
- Identify the target user, valuable outcome, current evidence, constraints, and
  non-goals. Do not invent metrics, priorities, personas, or policy.
- Challenge an XY problem, hidden scope expansion, or a solution that does not
  address the stated outcome.
- Keep implementation details out unless they constrain product behavior,
  compatibility, rollout, or acceptance.
- Treat a decision that changes scope, priority, permissions, data handling, or
  release behavior as open until the user or authoritative source resolves it.

## Requirement

Use only sections that help execution:

1. problem and context;
2. goal and non-goals;
3. users and key scenarios;
4. in-scope behavior;
5. testable acceptance criteria;
6. constraints, dependencies, risks, and open decisions.

Write user stories only when they clarify a distinct user task. Acceptance
criteria describe observable outcomes, not UI click paths, API implementation,
or test scripts. Ensure each core goal maps to at least one scoped behavior and
acceptance criterion.

Mark the result as a draft when unresolved decisions or missing evidence can
change what must be built or tested. Otherwise state that it is ready for
technical design or test planning. Keep future ideas outside the current scope
rather than making the initial release silently larger.
