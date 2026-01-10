---
name: refactor
description: Use when changing code structure with intended behavior changes (performance optimizations, rewrites, module splits, sync-to-async, data model shifts, cleanup that may alter outputs or timing) - enforces explicit behavior boundaries, baseline tests, and verification to prevent regressions.
---

# Refactor

## Overview
Define behavior boundaries first, then refactor under test protection. Timing and concurrency changes are behavior changes.

## Required Sub-Skills
- **REQUIRED SUB-SKILL:** superpowers:test-driven-development
- **REQUIRED SUB-SKILL:** superpowers:verification-before-completion

## Core Workflow
1. Define intent + behavior boundaries
2. Establish baseline (tests + key metrics)
3. Implement in small steps
4. Verify behavior and performance
5. Record change scope + rollback point

## Behavior Boundary Checklist
- Public APIs and return shapes
- Data schema and migration compatibility
- Output ordering and formatting
- Error types, messages, and status codes
- Timing, concurrency, and side effects
- Resource usage (CPU, memory, I/O)

## Quick Reference
| Step | Output |
| --- | --- |
| Boundaries | Explicit list of allowed behavior changes |
| Baseline | Tests + metrics proving current behavior |
| Change | Small, reviewable refactor commits |
| Verify | Regression tests + perf checks |
| Record | Change log + rollback plan |

## Example
```ts
type Api = {
  fetchUser(): Promise<{ id: string }>;
  fetchPosts(): Promise<string[]>;
};

// Boundary: output contract and errors stay the same; timing may change.
test('loadUserProfile keeps output contract', async () => {
  const api: Api = {
    fetchUser: async () => ({ id: 'u1' }),
    fetchPosts: async () => ['p1', 'p2'],
  };

  await expect(loadUserProfile(api)).resolves.toEqual({
    userId: 'u1',
    postCount: 2,
  });
});

export async function loadUserProfile(api: Api) {
  const [user, posts] = await Promise.all([
    api.fetchUser(),
    api.fetchPosts(),
  ]);

  return { userId: user.id, postCount: posts.length };
}
```

## Common Mistakes
- Skipping baseline tests because "it's just a refactor"
- Expanding scope with "while I'm here" changes
- Treating performance claims as a substitute for tests
- Changing behavior without documenting the boundary
- No rollback plan for risky changes

## Rationalizations vs Reality
| Excuse | Reality |
| --- | --- |
| "Refactor doesn't change behavior" | Timing and side effects change behavior. Define boundaries. |
| "Manual testing is enough" | Manual testing doesn't prevent regressions. Baseline tests do. |
| "Feature flags make tests optional" | Flags reduce blast radius, not verification. |
| "We can add tests later" | Tests after refactor don't prove safety of the change. |
| "Too late to back out" | Sunk cost is not a quality strategy. |

## Red Flags - STOP
- No explicit behavior boundary list
- Baseline tests missing or failing
- "I'll add tests after"
- "This is only cleanup"
- Broad cross-module changes without scope control
