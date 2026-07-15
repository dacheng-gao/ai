---
name: superagents
description: Use when one request spans multiple distinct work lanes, needs coordination across independent subtasks, or requires several agents with clearly separable evidence or write ownership.
---

# Superagents

Coordinate only work that benefits from coordination.

## Entry Check

- Identify the user's outcome and the distinct lanes involved.
- If one skill or the primary agent can complete the request coherently, stop
  using this coordinator and take that direct path.
- Do not invoke agents merely to assign roles, repeat analysis, or make a small
  task look rigorous.
- Resolve material product decisions and ambiguous shared boundaries before
  parallel work begins.

## Coordination

1. Split work into bounded tasks with explicit input, output, evidence, and stop
   conditions.
2. Delegate only tasks that are independent or gain meaningful context
   isolation. Keep user interaction, integration decisions, and final judgment
   with the primary agent.
3. Use `superpowers:dispatching-parallel-agents` only when tasks do not
   depend on each other's results or modify the same state.
4. Give each writer exclusive ownership of its files or responsibility. Serialize
   overlapping changes and re-read shared state before integration.
5. Review returned evidence rather than trusting completion claims. Resolve
   conflicts against the user's goal, safety, correctness, and current source of
   truth.
6. Verify the integrated result at the scope of the whole request.

Report one synthesized outcome, not a transcript of agent roles. State delegated
scope, integrated evidence, unresolved conflicts, and residual risk only when
they help the user assess the result.
