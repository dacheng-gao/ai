---
name: develop-feature
description: Use when adding a new feature or enhancement, especially with unclear requirements or multi-file impact - enforces a two-phase research/plan approval gate with evidence, then TDD + verification before completion.
---

# Develop Feature

## Overview
Two-phase gate: research/plan, approval, then TDD + verification.

## When to Use
- New feature, enhancement, endpoint, UI flow, integration, data model
- Multi-file change or unclear requirements

**When NOT to Use**
- Bug fix only -> use fix-bug; refactor only -> use refactor workflow

## Required Sub-Skills
- **REQUIRED SUB-SKILL:** superpowers:test-driven-development
- **REQUIRED SUB-SKILL:** superpowers:verification-before-completion

## Quick Reference
| Phase | Gate | Output |
|---|---|---|
| 1. Planning | approval | evidence, approach, scope |
| 2. Implementation | tests + verification | code + tests, validation, deviations |

## Phase 1: Planning & Design

**Rules:**
- No implementation code or tests in Phase 1
- Cite evidence (paths/functions/patterns)
- Missing info -> search or ask
- If asked to skip planning or "just implement", refuse and continue only after plan approval

**Mandatory Context Checklist**
- Scope + success criteria
- Architecture docs: `AGENTS.md`, `README.md`, `docs/`
- Existing patterns/utilities (cite files/functions)
- Dependencies/constraints + integration points + open questions

**Implementation Plan Must Include**
1. **Summary** — what/why, success criteria
2. **Evidence** — files checked, patterns/utilities, constraints
3. **Approach + Scope** — alternatives, tradeoffs, files, tests, edge cases, compatibility, perf, security, rollout/rollback
3. **Approach + Scope** — alternatives, tradeoffs, files, tests, edge cases, compatibility, perf, security

**End Phase 1 with**
> "Does this plan look good? Say 'proceed' or 'approved' to begin implementation."

---

## Phase 2: Implementation

**Rules:**
- Only enter after approval (e.g., "proceed")
- Follow TDD + verification; deviations require stop + approval

**Implementation Checklist**
- Follow approved design; log deviations and rationale
- Write failing test first (TDD), then minimal code
- Match existing patterns; handle errors
- Run tests + lint/format before completion claims
- Provide validation steps

**If you already wrote code before approval**
Delete or stash it and restart from Phase 1. Retroactive planning is a violation.

## Example Plan
```markdown
Requirement: CSV export on Reports page
Success: download CSV A,B,C <2s
Research: ReportPage.tsx; reports API; utils/csv.ts
Approach: client-side export (rec) /reports/export endpoint
Scope: ReportPage + ReportPage.test.tsx
Considerations: 10k cap, permissions
```

## Common Mistakes and Rationalizations
| Thought | Reality |
|---|---|
| "It's small/urgent, I can skip the plan" | Skipping plan ships wrong output. Plan anyway. |
| "I already wrote code / quick spike first" | Retroactive planning != plan. Restart Phase 1. |
| "I'll assume defaults or skip questions" | Assumptions cause rework. Ask/research. |
| "I'll run tests after" | Not TDD. Write tests first. |

## Red Flags - STOP
- You started implementation or tests before Phase 1 approval
- You cannot cite file paths or functions for research claims
- You are guessing requirements, edge cases, or constraints
- You are asked to skip planning or "just push a quick patch"
