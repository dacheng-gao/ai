---
name: evolve-architecture
description: Guide software architecture design and evolution when system boundaries, cross-module flows, quality attributes, or material trade-offs affect the outcome. Exclude local refactors and routine feature work without architectural consequences.
---

# Software Architecture Design And Evolution

Use this skill for a new system design, an architecture review, or a change to an existing system. Make the smallest architecture decision that addresses the observed need and preserves useful options for later change.

## Establish the decision

Clarify the desired business or user outcome, system boundary, lifecycle stage, team ownership, deployment environment, constraints, and affected quality attributes. Treat inferred intent as an assumption. Gather evidence from the repository, runtime behavior, operational data, incidents, change history, and team boundaries as available. A folder pattern or framework name alone does not establish an architectural problem.

State each material problem as a scenario with its observed consequence, likely cause, evidence quality, and uncertainty. Trace representative request, data, dependency, and failure paths. Inspect data ownership, consistency needs, concurrency, security, performance, reliability, operability, and delivery constraints only where they can change the decision.

## Choose a shape

Define module or service responsibilities, public contracts, dependency directions, data ownership, transaction and consistency boundaries, and the failure semantics of important flows. Prefer a clear modular monolith when independent deployment, scaling, or fault isolation is not yet evidenced. Use layers, hexagonal boundaries, events, microservices, Serverless, or other forms when their specific constraints and benefits are relevant; do not treat a pattern, language, or framework as a maturity signal.

Account for the selected language ecosystem: type and ownership guarantees, runtime and concurrency model, package and build tooling, testing support, deployment model, observability, and the team's operational capability. Let these constraints influence implementation choices without confusing ecosystem conventions with business boundaries.

Compare feasible alternatives, including keeping the current design when credible. Give each alternative its strongest case and evaluate it against grounded requirements, complexity, migration cost, reversibility, team ownership, operational burden, and failure behavior. Do not invent preference weights or precision. Make the assumptions that would reverse the recommendation explicit.

## Evolve safely

For an existing system, describe the current and target responsibilities, contracts, critical flows, compatibility requirements, and data migration plan. Prefer incremental changes that can be deployed, observed, and rolled back independently. For APIs, events, and schemas, account for compatibility, versioning, duplicate delivery, retries, timeouts, idempotency, and partial failure. Use a sequence such as introduce compatibility, migrate traffic or data, verify behavior, then remove obsolete paths when it fits the system.

Tie each step to an observable acceptance signal: tests, traces, metrics, latency or error behavior, deployment checks, or operational feedback. Separate source inspection, experiments, implemented behavior, and unverified production claims. Include rollback or containment conditions for consequential changes.

## Deliver the requested artifact

Match the response to the request. A design or review should make the decision, boundaries, trade-offs, risks, assumptions, and verification path easy to assess. A brainstorm should present transferable principles and contrasting examples across relevant language ecosystems without implying one universal architecture. An implementation request may continue into code changes after the architecture decision, with the same evidence and validation discipline.

Do not prescribe DDD, microservices, CQRS, or extra layers without an evidenced problem they solve. Do not optimize for theoretical future scale at the expense of current delivery unless the constraint is evidenced. Stop after a review or design artifact when that is the request; explicit implementation authorization does not require repeated approval.
