---
name: answer
description: Use when the user wants repository-grounded explanation, technical analysis, a command, or an approach comparison without asking for implementation or remediation.
---

# Answer

Answer the actual question from the smallest sufficient evidence set.

## Boundaries

- Keep the task read-only. Do not edit files, create commits, or change external
  state unless the user separately asks for that action.
- Inspect repository context when the answer depends on current code, history,
  configuration, or behavior. Do not replace evidence with general knowledge.
- Distinguish observed facts, inferences, assumptions, and unknowns.
- If investigation reveals a bug or the user asks for a change, hand off to the
  applicable implementation skill instead of silently expanding scope.

## Method

1. Identify the decision or explanation the user needs.
2. Read only the relevant sources and verify drift-prone facts when practical.
3. Explain the behavior, cause, or trade-off directly. Use scenarios or a small
   example only when they materially improve understanding.
4. Cite useful file locations, commands, or primary sources.

Lead with the answer. Include limitations or the next diagnostic step only when
they affect the conclusion.
