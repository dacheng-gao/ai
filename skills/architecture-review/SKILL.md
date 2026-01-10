---
name: architecture-review
description: Use when assessing system architecture, platform design, or high-level codebase structure (scalability, reliability, performance bottlenecks, coupling, data consistency, operational risk) - produces a health checklist with risk levels and concrete fixes, and flags missing inputs.
---

# Architecture Review

## Overview
Assess risk using evidence, then produce a checklist with risk levels and fixes. Do not redesign unless asked.

## Required Inputs (ask if missing)
- Goals, SLOs, and non-functional requirements
- Traffic, data volume, and growth profile
- Topology diagram and data flow
- Critical user journeys and failure modes
- Constraints: latency, cost, compliance, team size
- Incident history or known hotspots

## Output Format
Use this structure:

```markdown
Checklist
- Area: <boundary/data/scale/reliability/security/observability/deploy/cost>
  Risk: Critical | Important | Suggestion
  Evidence: <file/metric/trace/diagram note>
  Impact: <user or system impact>
  Fix: <concrete change>

Summary
- Stop-ship risks: <count + short list>
- Next steps: <top 1-3 fixes>
```

## Review Workflow
1. Define scope and constraints
2. Gather evidence (docs, code touchpoints, metrics)
3. Identify risks per area
4. Propose fixes with clear scope
5. Prioritize by impact and urgency

## Checklist Areas
- Boundaries and coupling
- Data flow and consistency
- Scalability and capacity
- Reliability and failure recovery
- Security and access control
- Observability and operability
- Deployment and rollback
- Cost and efficiency

## Quick Reference
| Step | Output |
| --- | --- |
| Scope | Stated assumptions or missing inputs |
| Evidence | Cited docs/metrics/paths |
| Risks | Checklist with severity |
| Fixes | Concrete, scoped actions |
| Priority | Top 1-3 fixes |

## Example
```markdown
Checklist
- Area: scalability
  Risk: Important
  Evidence: api reads all rows without pagination
  Impact: p95 latency spikes under peak load
  Fix: add pagination + index; cap page size

Summary
- Stop-ship risks: 0
- Next steps: add pagination, add index
```

## Common Mistakes
- Generic advice without evidence
- Missing risk level or fix per item
- Treating review as a redesign
- Ignoring runtime constraints or SLOs
- Skipping assumptions when inputs are missing

## Rationalizations vs Reality
| Excuse | Reality |
| --- | --- |
| "No docs, so give generic advice" | Ask for missing inputs or state assumptions. |
| "Need a quick yes/no" | Provide checklist with stop-ship risks. |
| "Architecture review equals redesign" | Diagnose first, fix only what is asked. |
| "I know the system, no evidence needed" | Cite artifacts or metrics to avoid guesswork. |

## Red Flags - STOP
- No scope or constraints defined
- Checklist lacks risk level or fix
- No evidence or assumptions stated
- Only summary, no checklist
