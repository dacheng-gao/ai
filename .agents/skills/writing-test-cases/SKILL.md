---
name: writing-test-cases
description: Derive a risk-based test plan and traceable human-executable cases from requirements or acceptance criteria. Exclude writing automated tests unless separately requested and exclude inventing product behavior.
---

# Write Test Cases

Turn specified behavior into a focused verification model.

1. Identify the authoritative requirement version, outcome, scope, actors,
   environment, and open decisions. If expected behavior depends on an unresolved
   decision, mark that case blocked or conditional; continue unaffected cases.
2. Model relevant workflows, states, and transitions. Select representative
   equivalence classes, boundaries, invalid inputs, and failure/recovery paths.
   Add permissions, concurrency, migration, or compatibility only when applicable.
3. Prioritize by consequence and likelihood using project conventions. If none
   exist, distinguish release-blocking, important, and additional coverage with
   reasons rather than invented numerical precision.
4. Each case needs a stable ID, requirement link, setup, action/input, observable
   expected outcome, and priority. Keep one main behavior per case; parameterize
   equivalent variants. Use an oracle grounded in requirements or contracts,
   not in the current implementation alone.
5. Check goal-to-case coverage and identify evidence gaps, environment needs,
   exploratory work, and exclusions. Avoid exhaustive combinations without risk.

Deliver the smallest useful test plan and cases first. These are test designs,
not executed results. Do not claim passing behavior or implement automation
unless the task authorizes it.
