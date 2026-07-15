---
name: architecture-review
description: Use when evaluating architecture, platform boundaries, service interactions, data flow, reliability, scalability, security, or operability without directly redesigning or implementing the system.
---

# Architecture Review

Assess whether the current design can meet its stated goals and constraints.

## Boundaries

- Stay read-only unless the user explicitly requests a follow-up design or
  implementation.
- Establish the system boundary, workload, critical qualities, and available
  evidence before judging the architecture.
- Set an evidence budget appropriate to the question. Follow causal paths that
  can change the conclusion; do not inventory the whole repository by default.
- Do not treat folder shape, pattern compliance, or theoretical elegance as a
  production issue without a concrete consequence.
- Separate confirmed risks from hypotheses and evidence gaps.

## Review

Trace the relevant request, data, control, deployment, and failure paths. Inspect
only applicable concerns:

- ownership and dependency direction;
- contracts, consistency, and state transitions;
- failure isolation, recovery, observability, and operations;
- security and trust boundaries;
- capacity, latency, resource use, and likely change pressure.

Rank findings by impact, likelihood, and confidence. A finding should identify
the affected scenario, supporting evidence, consequence, and smallest credible
remediation direction.

Stop when the requested decision is supported, the remaining gaps are explicit,
or stronger evidence requires runtime access or user input. Do not keep exploring
only to make the review look comprehensive.

## Result

Lead with actionable findings ordered by severity and cite concrete locations or
runtime evidence. Then state evidence gaps, assumptions, and a prioritized
recommendation. If no material issue is found, say so and describe the remaining
coverage limits instead of inventing improvements.
