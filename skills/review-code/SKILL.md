---
name: review-code
description: Use when asked to review code, PRs, diffs, or patches for correctness, security, performance, or maintainability risk - produces a severity-ranked, location-cited review with concrete fixes, assumptions, and minimal fluff.
---

# Review Code

## Overview
Find the highest-impact issues first, cite exact locations, and propose concrete fixes.

## When to Use
- Code review / PR review / diff or patch review
- Requests to check for bugs, security, performance, or maintainability issues
- Approval or pre-merge review

## When Not to Use
- No code or diff provided (ask for code)
- Only architecture/design discussion (use architecture review)

## Quick Reference

| Focus | Signals / examples |
| --- | --- |
| Correctness | off-by-one, null deref, wrong condition, missing error handling |
| Security | auth bypass, SQL injection, XSS/CSRF, secret leaks |
| Performance | N+1 queries, unbounded loops, blocking I/O |
| Maintainability | unclear naming, duplication, complex branching |
| Best practices | framework conventions, logging, error handling |

## Output Format
- Findings first, ordered by severity.
- Each finding includes: location (file:line or snippet), severity, impact, fix.
- Then open questions/assumptions.
- Then 1-2 sentence summary.
- Optional positives (only if meaningful).
- If no findings, say so explicitly and note residual risks or testing gaps.
- If essential context is missing, ask one critical question; otherwise state assumptions.

## Severity Rubric
- Critical: security, auth bypass, data loss, crash/panic
- Important: logic bugs, perf regressions, flaky behavior
- Suggestion: readability, naming, small refactors

## Time-Boxed Reviews
If time or authority pressure exists, time-box but still scan highest-risk areas (auth, input validation, data writes, concurrency). State what was reviewed and what was not.

## Example
```markdown
Findings
- b/api/users.ts:42
  Severity: Critical
  Issue: Missing auth/ownership check allows any user to update profiles.
  Fix: Require `requireUser()` and verify `user.id` matches target.

- b/db/users.ts:88
  Severity: Important
  Issue: Unbounded query can cause N+1 behavior under load.
  Fix: Add LIMIT and batch fetch related data.

Questions/Assumptions
- Is `req.user` always set by middleware before this handler?

Summary
- Block merge until auth check is added; performance issue can follow.
```

## Common Mistakes
- Starting with summary before findings
- Missing locations or severity
- Nitpicking style while ignoring correctness/security/perf
- Vague fixes ("optimize") without concrete action

## Rationalizations vs Reality

| Excuse | Reality |
| --- | --- |
| "No time for line numbers" | No location = no fix; cite file and snippet at minimum. |
| "User asked for quick review" | Quick still needs high-severity issues first. |
| "Be nice, avoid negatives" | Hidden critical issues cause real harm. |
| "No findings, so I'll just say looks good" | Explicitly state no findings and list residual risks or testing gaps. |

## Red Flags - STOP
- "I'll just skim and approve"
- "Only style comments"
- "No file/line references"
- "Summary only, no findings"
- "No findings stated"
