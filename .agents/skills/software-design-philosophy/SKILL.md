---
name: software-design-philosophy
description: "Evaluate or design software modules, APIs, and architecture with a complexity-first approach: make boundaries deep, hide information, concentrate change, and reduce the cost of future modification. Use for architecture decisions, significant refactors, and design reviews; do not invoke for routine local edits with no meaningful design choice."
---

# Complexity-first software design

Apply these principles when a task involves module boundaries, public APIs, service decomposition, data ownership, or a non-trivial refactor. The goal is to reduce the system-wide cost of understanding and changing code, not to maximize abstraction, layers, or component count.

## Start with the complexity

- Identify the change the design must support, the details a caller currently needs to know, and the places a rule or decision is duplicated.
- Treat dependencies, information leakage, special cases, and non-obvious control flow as complexity signals.
- Prefer the smallest design that hides the relevant complexity and leaves a clear path for evidence-driven evolution.

## Shape boundaries

- Prefer deep modules: a small, semantic interface that hides substantial implementation knowledge. Reject shallow wrappers that merely forward calls or rename technical details.
- Organize code around business capability or a stable reason for change; keep API, application, domain, and infrastructure concerns inside that boundary when useful.
- Keep one authoritative owner for each business rule, data interpretation, and external-system policy. Prevent database schemas, vendor protocols, and transport details from leaking into callers.
- Make interfaces explicit and semantically meaningful. A caller should ask for an intention (for example, `findPendingOrders`) rather than reconstructing storage mechanics.
- Do not split a module merely because it is large, or merge modules merely because code is shared. Use coupling, change impact, and information ownership as evidence.

## Choose deliberately

- For important decisions, compare at least two plausible designs and explain the trade-off in complexity, failure behavior, testability, operations, and future change cost.
- Distinguish strategic design work from tactical patches. Spend design effort where a decision will be repeated, widely depended on, or expensive to reverse; keep low-risk local choices simple.
- Do not speculate about every possible future. Generalize only around observed or strongly constrained variation, and record assumptions that would justify revisiting the boundary.
- Treat duplication as a signal to investigate, not an automatic refactoring target. Duplication can be safer than a premature shared abstraction when the concepts may diverge.

## Review implementation quality

Check whether the proposed design:

1. Reduces the knowledge required by callers and future maintainers.
2. Localizes likely changes instead of scattering them across layers or services.
3. Makes the common path obvious and contains exceptional cases.
4. Keeps dependencies directional and prevents convenience access across boundaries.
5. Can be tested at the boundary that owns the behavior, without reconstructing the whole system.
6. Includes an explicit migration or rollback path when changing a public contract or data boundary.

When reviewing or proposing architecture, state the conclusion first, then the evidence, assumptions, rejected alternatives, and the signal that would justify changing the decision. Apply the principles proportionally; this skill does not require a particular architecture style, language, framework, or microservice adoption.
