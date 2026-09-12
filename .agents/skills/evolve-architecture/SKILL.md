---
name: evolve-architecture
description: Evaluate or design changes to an existing system when domain boundaries, cross-module flows, or material quality trade-offs are the decision. Exclude local refactors and routine feature work without such trade-offs.
---

# Evolve Architecture

Improve architecture from actual change pressure and system evidence.

1. Establish the business outcome, system boundary, constraints, affected quality
   attributes, and evidence. Trace representative request, data, and failure
   paths; folder shape or pattern compliance alone does not establish a problem.
2. State each material problem as an affected scenario with observed consequence,
   likely cause, and uncertainty. Inspect ownership, dependencies, consistency,
   failure isolation, and operational constraints only where they change the decision.
3. Compare feasible alternatives, including keeping the current design when
   credible. Give each its strongest case. Evaluate against grounded requirements,
   migration cost, reversibility, and failure behavior without invented weights.
4. For a requested design, describe changed responsibilities and contracts,
   critical flows, compatibility, failure/recovery semantics, and a staged,
   independently verifiable evolution path. Name assumptions whose change would
   reverse the recommendation.
5. Stop after a review or design artifact when that is the request. Explicit
   implementation authorization needs no repeated approval; carry authorized
   changes through appropriate feature, bug-fix, or refactoring work.

Do not prescribe DDD, microservices, CQRS, or extra layers without an evidenced
problem they solve. A credible design is not runtime proof: distinguish source
analysis, experiments, implemented behavior, and unverified operational claims.
