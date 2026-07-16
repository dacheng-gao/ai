---
name: evolve-architecture
description: Use when evaluating or evolving an existing system's architecture, business or domain boundaries, cross-module flows, dependencies, reliability, scalability, security, or operability.
---

# Evolve Architecture

Improve an existing architecture from evidence and actual business needs.
Theory is a decision aid, not a target architecture.

## Boundaries

- Keep review requests read-only. Design or implement only when asked.
- Establish the system boundary, business goals, change pressure, critical
  qualities, constraints, and evidence before judging the design.
- Inspect only causal paths that can change the conclusion; do not inventory the
  repository by default.
- Separate confirmed facts, hypotheses, and evidence gaps. Do not treat folder
  shape, pattern compliance, or theoretical elegance as a problem without a
  concrete consequence.
- Preserve existing contracts, data semantics, and unexplained user changes.

## Understand The System

Reconstruct representative request, data, control, deployment, and failure
paths. Identify:

- business capabilities, subdomains, vocabulary, rules, data ownership, and
  public contracts;
- dependency direction and collaboration across domain or module boundaries;
- critical flows from entry through orchestration, decisions, state changes,
  transaction boundaries, events or side effects, errors, compensation, and
  outcome;
- coupling, consistency, concurrency, idempotency, failure isolation, recovery,
  observability, security, capacity, operability, readability, and testability.

Rank findings by impact, likelihood, and confidence. Tie each finding to an
affected scenario, evidence, consequence, root cause, and smallest credible
remediation direction. If the current design is adequate, say so.

## Design The Evolution

When design is requested, derive the target from confirmed problems. Define:

- target boundaries, responsibilities, ownership, public contracts, and allowed
  dependencies;
- the critical business flows and their consistency and failure semantics;
- the current-to-target mapping and what stays, moves, splits, merges, or leaves;
- alternatives, trade-offs, compatibility impact, and the simplest adequate
  option;
- an ordered, independently verifiable, reversible evolution path.

Apply DDD, modularity, information hiding, high cohesion and low coupling,
Clean or Hexagonal Architecture, event-driven design, CQRS, or distributed
systems patterns only when they solve an evidenced problem. Do not introduce
microservices, layers, abstractions, or extension points without demonstrated
need.

## Gate And Deliver

Before changing domain boundaries, public contracts, data or persistence,
cross-module dependencies, deployment topology, or moving code broadly, explain
the trade-offs and obtain user approval. When evidence is missing, identify the
smallest way to acquire it.

After approval, evolve through working vertical slices. Use `refactor`,
`develop-feature`, or `fix-bug` for each slice instead of duplicating its
workflow. Keep the architecture decision and acceptance criteria visible;
update only supporting tests, documentation, configuration, and observability.

For reviews, report findings, evidence gaps, assumptions, and priorities. For
evolution designs, add the business and domain map, critical flows, target,
alternatives, staged plan, verification, rollback, decisions, and residual risk.
Claim completion only with current test, build, and feasible runtime evidence
for affected behavior and contracts.
