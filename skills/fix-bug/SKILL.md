---
name: fix-bug
description: Use when a defect, regression, failing test, crash, or incorrect output needs a minimal, validated fix with clear reproduction or evidence.
---

# Fix Bug

## Overview

Find the root cause with evidence, then apply the smallest safe change and verify it. Confirm only for high-risk or irreversible changes; otherwise proceed with documented scope.

## When to Use

- Failing tests, regressions, crashes, incorrect output, performance drops, flaky behavior
- Stack traces, error logs, exceptions, timeouts, user reports with repro steps
- You need to correct existing behavior, not add new features

**When NOT to use**
- New feature or large behavior change (use develop-feature)
- Broad refactors or redesigns (switch to refactor workflow)

## Core Pattern

1. Observe: capture the exact failure (log/stack trace/failing test)
2. Reproduce: minimal repro or targeted logging
3. Isolate: trace input -> failure and identify the first wrong assumption
4. Fix: smallest change that addresses the cause
5. Verify: rerun the repro + relevant regression checks

## Quick Reference

| Step | Goal | Evidence |
| --- | --- | --- |
| Observe | What fails and where | stack trace, logs, failing test |
| Reproduce | Make it fail on demand | minimal repro, targeted logging |
| Isolate | Find the first wrong assumption | code trace, git bisect |
| Fix | Minimal, safe change | smallest diff, avoid refactor |
| Verify | Prove it is fixed | test command, manual steps |

## Implementation

- Start from evidence, not hunches; cite files/functions/lines you checked.
- If repro is missing, add temporary logging or a focused failing test before changing code.
- Prefer local, reversible changes; inform when touching multiple modules and ask only if scope expands or risk increases.
- Explain why the change fixes the root cause (not just what changed).

**High-Risk Confirmation Triggers**
- Destructive or irreversible operations (data deletion, history rewrite, breaking migrations)
- Security/auth or sensitive data handling changes
- Breaking API/contract changes or compatibility risks

## Example

**Symptom:** `TypeError: Cannot read properties of undefined (reading 'id')`  
**Root cause:** `user` can be `undefined` when auth token is expired.  
**Fix (minimal guard):**

```ts
// before
const userId = user.id;

// after
if (!user) return res.status(401).end();
const userId = user.id;
```

**Verify:** add test "expired token returns 401" + rerun the failing endpoint.

## Common Mistakes

- Patching symptoms (try/catch) without locating the cause
- Guessing without repro or evidence
- Broad refactors for a small bug
- Skipping validation or regression checks
- Disabling tests or increasing timeouts to "get green"

## Rationalizations vs Reality

| Excuse | Reality |
| --- | --- |
| "No time to reproduce" | Fixing blind causes regressions; build a minimal repro or log. |
| "Quick try/catch is fine" | It hides failures; fix where the bad data is introduced. |
| "Refactor to be safe" | Bigger changes increase risk; start with the smallest fix. |
| "I must ask before touching multiple modules" | Inform the scope change; ask only if risk increases. |

## Red Flags - STOP

- "Just add a try/catch"
- "Disable the test for now"
- "Can't reproduce, so guess"
- "Let's refactor everything"
- "Ship without verification"
- "High-risk change without explicit confirmation"
