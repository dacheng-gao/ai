---
name: evaluate-guidance
description: Evaluate proposed AGENTS.md rules, skill triggers, or agent hooks against existing guidance using controlled representative tasks. Use for reusable agent guidance changes; exclude ordinary product test plans and syntax-only validation.
---

# Evaluate Guidance

Determine whether a guidance change improves the user's actual task outcomes.

1. State the observed failure or testable benefit, affected task category, and
   baseline/candidate versions. Record the host, model, tools, permissions,
   repository snapshot, and loaded guidance. Do not assume installed means loaded.
2. Choose realistic tasks and non-matching controls. Include scope boundaries,
   simple work, material ambiguity, existing user changes, and unavailable
   evidence where relevant. Define observable outcomes before inspecting results.
   Hold evaluation expectations apart from the agent's working context.
3. Run authorized trials in isolated equivalent environments. Compare baseline
   and candidate on the same tasks; keep other settings fixed and vary task order
   or repeat where variance could change the decision. Inspect actual artifacts,
   tool effects, and answers, not the agent's self-reported score.
4. Track outcome correctness, scope violations, missed or unnecessary questions,
   trigger precision and recall, completion, tool calls, elapsed time, and token
   usage when available. Use deterministic checks for state and outputs, and
   human-calibrated judgment for intent. Do not merge these into invented weights.
5. Investigate regressions by changing one guidance component at a time. Keep
   holdout tasks and failures as regression cases; do not overfit wording or
   reward longer explanations, more tools, or more agents.
6. Recommend retain, revise, remove, or gather more evidence. State sample limits,
   trade-offs, and what evidence would reverse the recommendation. If trials
   cannot run, deliver an evaluation design and mark benefits unverified.

Do not modify global configuration, contact external services, or launch costly
trials outside the authorized scope. Metadata validation proves discoverability
structure, not effectiveness. Stop when evidence supports the decision or the
remaining gap cannot be resolved within scope.
