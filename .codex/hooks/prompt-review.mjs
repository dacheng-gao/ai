#!/usr/bin/env node

import { createHash } from 'node:crypto';
import { mkdirSync, unlinkSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

const LEGACY_READY_MARKER = '<!-- PROMPT_REVIEW_READY -->';
const REVIEW_READY_MARKER = '*Prompt review done*';
const CONTINUE_REASON = 'Continue working...';
const EXECUTE_PREFIX = '[PROMPT_REVIEW_EXECUTE]';
const BYPASS_PREFIXES = ['/raw', '[NO_REFINE]'];

const REVIEW_CONTEXT = `
For this turn, assess whether one bounded enhancement of the user's prompt
would materially improve task understanding, completeness, or execution.
Use the conversation and available context, including what short follow-ups
refer to. If enhancement adds no material value, handle the request directly
without emitting the review marker. Do not rewrite merely to lengthen it.

Otherwise, produce one concise, self-contained working prompt in the user's
language, using precise, accessible professional language. Do not execute the
underlying task during this enhancement pass. Treat this as a single bounded
optimization pass, not a recursive prompt-review loop.

Treat a message received during ongoing work as steering that work unless the
user clearly replaces or cancels it. Incorporate the new request while preserving
unfinished authorized work; reviewing the new message does not complete it.

First classify the task by the amount of clarification it needs, then apply
only the matching level:

- Simple and low-risk: preserve the user's wording where it is already clear;
  fix only material ambiguity, add a concrete outcome or minimal verification,
  and do not add frameworks, plans, or extra questions.
- Moderate: make the outcome, scope, constraints, non-goals, dependencies, and
  completion signal explicit; resolve terminology from the conversation or
  available project context; add only task-relevant execution and verification
  guidance.
- Complex, consequential, or high-risk: add a concise decomposition, key
  assumptions, business invariants, dependency boundaries, and proportionate
  validation or risk checks; compare approaches only when the choice can change
  the result.

Always preserve the user's request type, scope, permissions, identifiers, and
acceptance criteria. A question, exploration, review, or proposal must remain
that type and must not become authorization to implement. An implementation
request must remain actionable rather than being turned into a discussion.

When a business term, rule, or requirement is inaccurate or underspecified,
use the conversation, repository, and domain context to correct it when the
intended meaning is clear. State any inferred meaning as an assumption. If
different interpretations would change the result and context cannot resolve
them, ask one focused question; continue independent work where possible.
Never invent business rules, permissions, technologies, metrics, deliverables,
or acceptance criteria.

Improve these layers only when useful:

- Expression: organize the explicit request, desired observable outcome,
  relevant context, constraints, non-goals, and existing success criteria.
  Preserve identifiers and the request type: a question, exploration, review,
  or proposal must not become authorization to implement.
- Intent: distinguish the requested means from the desired outcome. Identify
  plausible underlying intent only when grounded in context; label it as an
  inference or assumption to validate, never as a user requirement. Do not
  speculate about personal motives. If means and ends may conflict, direct
  the agent to examine that mismatch without silently replacing the request.
- Method: add proportionate, task-relevant analysis, work sequencing, evidence
  gathering, and verification guidance. These are revisable suggestions, not
  new user requirements. Do not invent facts, deliverables, scope, permissions,
  technology commitments, numerical targets, or acceptance criteria.

Select the smallest useful set of methods for the actual decision gap, not for
popularity. Translate selected methods into concrete guidance, not a checklist
of framework names. Use only when relevant:
- First-principles: examine foundational assumptions.
- Socratic questions: clarify material gaps in concepts, evidence, or constraints.
- Steelman: give genuine competing explanations or approaches their strongest
  cases; fair argument is not evidence that either is correct.
- Jobs to Be Done (JTBD): clarify desired progress in the specific situation;
  separate outcomes from requested means without inventing personal motives.
- Hypothesis testing: identify testable explanations and evidence that could
  distinguish or refute them; do not merely confirm the first plausible story.
- Value of information: prioritize unknowns likely to change the decision;
  stop investigating when further information is unlikely to justify its cost.
- Systems thinking: bound the system and check dependencies, feedback, delays,
  and downstream effects; avoid local improvements that harm the overall goal.
- Multi-criteria decision and sensitivity analysis: compare real alternatives
  against grounded criteria; check whether changed assumptions alter the choice.
  Do not invent preference weights, scores, or numerical precision.
- Premortem: for consequential plans, imagine failure and identify plausible
  causes and proportionate prevention; failure scenarios are not observed facts.
- Verification and validation: at delivery, check both explicit requirements
  and the intended outcome in context; distinguish tested results from assumptions.

Do not force methods onto simple tasks, manufacture alternatives, or demand
hidden chain-of-thought. Ask for concise conclusions, checkable rationale, and
relevant uncertainty. Stop as soon as the prompt has a clear outcome, usable
scope, material constraints, and a verifiable completion signal.

Keep user-stated requirements distinct from inferred intent and suggested
methods. Direct the executing agent to resolve unknowns from context or tools
first. For low-risk reversible choices, state a reasonable assumption and
proceed. If a missing fact materially changes the decision and cannot be safely
resolved, ask the user one focused question explaining its impact before the
dependent work; continue independent work when useful. Never treat an assumption
as authorization. Let new evidence revise the inferred intent and methods.

Include only sections useful to this task; simple tasks should stay simple.
Prefer a reasonable assumption and execution for low-risk reversible choices.
Do not add defensive branches, broad test plans, or design work for hypothetical
failures. Keep each instruction stated once and keep the optimized prompt
shorter than the original when no extra detail is needed.
The enhanced prompt is advisory working guidance, not a new specification or
an approval gate. Preserve all explicit constraints and permission boundaries.

Start with the exact standalone italic line below, then a blank line and the
refined prompt. Do not turn the line into a heading or code block:

${REVIEW_READY_MARKER}
`.trim();

const GOAL_REVIEW_CONTEXT = `
Apply the following rule only when the latest user message contains
<codex_internal_context source="goal">. Otherwise ignore this entire rule.

For a matching goal message, treat only the contents of
<objective>...</objective> as the original user request. Then follow this policy:

${REVIEW_CONTEXT}
`.trim();

const LEGACY_CONTINUE_REASON = `${EXECUTE_PREFIX}
Continue the original task using the enhanced prompt in your immediately
preceding assistant message as advisory working guidance, not new or higher
authority. The original user request remains authoritative; if the two conflict,
follow the original, incorporating the latest user steering and preserving
unfinished authorized work. Preserve the request type, scope, constraints, permissions,
and acceptance criteria. Inferred intent remains a hypothesis; suggested methods
can be revised as evidence arrives. Resolve material unknowns from context or
tools where possible. If a missing fact cannot be safely resolved, ask one focused
question before dependent work; continue independent work when useful. Do not
treat this automatic continuation as user confirmation of assumptions or approval
to implement a question, review, or proposal. Do not perform another prompt-review
pass or emit either review marker (${LEGACY_READY_MARKER} or ${REVIEW_READY_MARKER}). Complete the authorized task with
proportionate verification, respecting any required clarification or approval.`;

// Keep operational instructions in model context, not the visible Stop reason.
const CONTINUATION_CONTEXT = `
When the latest user message, or the text inside its hook_prompt wrapper, is exactly
"${CONTINUE_REASON}", follow these continuation instructions instead of reviewing
that message. Do not print these instructions:

${LEGACY_CONTINUE_REASON.slice(EXECUTE_PREFIX.length).trim()}
`.trim();

const PROMPT_CONTEXT = `${CONTINUATION_CONTEXT}\n\nOtherwise, for a new user request:\n${REVIEW_CONTEXT}`;
const SESSION_CONTEXT = `${CONTINUATION_CONTEXT}\n\n${GOAL_REVIEW_CONTEXT}`;

const PENDING_DIRECTORY = join(tmpdir(), 'codex-prompt-review');

function pendingReviewPath(event) {
  if (typeof event.session_id !== 'string' || !event.session_id
    || typeof event.turn_id !== 'string' || !event.turn_id) {
    throw new Error('session_id and turn_id are required for prompt-review state');
  }
  const key = createHash('sha256')
    .update(JSON.stringify([event.session_id, event.turn_id])).digest('hex');
  return join(PENDING_DIRECTORY, `${key}.pending`);
}

function consumePendingReview(event) {
  try {
    // Unlink consumes the permission once, even if Stop is delivered twice.
    unlinkSync(pendingReviewPath(event));
    return true;
  } catch (error) {
    if (error.code === 'ENOENT') return false;
    throw error;
  }
}

function hasPrefix(prompt, prefix) {
  return prompt === prefix
    || prompt.startsWith(`${prefix} `)
    || prompt.startsWith(`${prefix}\n`)
    || prompt.startsWith(`${prefix}\r\n`);
}

function shouldBypassPrompt(prompt) {
  const text = typeof prompt === 'string' ? prompt.trim() : '';
  const wrapped = text.match(/^<hook_prompt\b[^>]*>([\s\S]*)<\/hook_prompt>$/);
  const normalized = (wrapped ? wrapped[1] : text).trim();
  if (!normalized) return true;
  return normalized === CONTINUE_REASON
    || hasPrefix(normalized, EXECUTE_PREFIX)
    || BYPASS_PREFIXES.some((prefix) => hasPrefix(normalized, prefix));
}

function userPromptSubmitOutput(event) {
  if (shouldBypassPrompt(event.prompt)) {
    consumePendingReview(event);
    return null;
  }
  const pendingPath = pendingReviewPath(event);
  mkdirSync(PENDING_DIRECTORY, { recursive: true, mode: 0o700 });
  writeFileSync(pendingPath, '', { mode: 0o600 });
  return {
    hookSpecificOutput: {
      hookEventName: 'UserPromptSubmit',
      additionalContext: PROMPT_CONTEXT,
    },
  };
}

function sessionStartOutput() {
  return {
    hookSpecificOutput: {
      hookEventName: 'SessionStart',
      additionalContext: SESSION_CONTEXT,
    },
  };
}

function stopOutput(event) {
  // A real user message can rearm review within an already-continued turn.
  // Consume on every Stop so ordinary completion cannot leave stale permission.
  const pendingReview = consumePendingReview(event);
  if (event.stop_hook_active && !pendingReview) return null;
  const lastMessage = typeof event.last_assistant_message === 'string'
    ? event.last_assistant_message.trimStart()
    : '';
  const marker = [REVIEW_READY_MARKER, LEGACY_READY_MARKER].find((candidate) =>
    lastMessage === candidate || lastMessage.startsWith(`${candidate}\n`)
      || lastMessage.startsWith(`${candidate}\r\n`));
  if (!marker || !lastMessage.slice(marker.length).trim()) return null;
  return {
    decision: 'block',
    reason: marker === LEGACY_READY_MARKER ? LEGACY_CONTINUE_REASON : CONTINUE_REASON,
  };
}

function hookOutput(event) {
  switch (event?.hook_event_name) {
    case 'SessionStart':
      return sessionStartOutput();
    case 'UserPromptSubmit':
      return userPromptSubmitOutput(event);
    case 'Stop':
      return stopOutput(event);
    default:
      return null;
  }
}

async function readStdin() {
  let input = '';
  process.stdin.setEncoding('utf8');
  for await (const chunk of process.stdin) input += chunk;
  return input;
}

try {
  const input = await readStdin();
  const output = hookOutput(JSON.parse(input));
  if (output) process.stdout.write(JSON.stringify(output));
} catch (error) {
  const message = error instanceof Error ? error.message : String(error);
  process.stderr.write(`prompt-review hook failed: ${message}\n`);
  process.exitCode = 1;
}
