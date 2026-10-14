import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

const script = fileURLToPath(new URL('./prompt-review.mjs', import.meta.url));
const review = '*Prompt review done*\n\nComplete the requested task.';
const continuation = { decision: 'block', reason: 'Continue working...' };

function hookFor(t) {
  const directory = mkdtempSync(join(tmpdir(), 'prompt-review-test-'));
  t.after(() => rmSync(directory, { recursive: true, force: true }));
  return (hook_event_name, fields = {}) => {
    const result = spawnSync(process.execPath, [script], {
      input: JSON.stringify({ session_id: 'session', turn_id: 'turn', hook_event_name, ...fields }),
      encoding: 'utf8',
      env: { ...process.env, TMPDIR: directory, TMP: directory, TEMP: directory },
    });
    assert.equal(result.status, 0, result.stderr);
    assert.equal(result.stderr, '');
    return result.stdout ? JSON.parse(result.stdout) : null;
  };
}

test('each new mid-turn request can continue once, including repeated wording', (t) => {
  const hook = hookFor(t);
  hook('UserPromptSubmit', { prompt: 'Create the migration.' });
  assert.deepEqual(hook('Stop', { stop_hook_active: false, last_assistant_message: review }), continuation);
  assert.equal(hook('UserPromptSubmit', { prompt: 'Continue working...' }), null);

  for (let i = 0; i < 2; i++) {
    hook('UserPromptSubmit', { prompt: 'Review the status naming too.' });
    assert.deepEqual(hook('Stop', { stop_hook_active: true, last_assistant_message: review }), continuation);
    assert.equal(hook('Stop', { stop_hook_active: true, last_assistant_message: review }), null);
  }
});

test('automatic continuations never rearm review, with or without a wrapper', (t) => {
  const hook = hookFor(t);
  for (const prompt of [
    'Continue working...',
    '<hook_prompt hook_run_id="stop:2:hooks.json">Continue working...</hook_prompt>',
    '[PROMPT_REVIEW_EXECUTE]\nContinue the original task.',
  ]) {
    assert.equal(hook('UserPromptSubmit', { prompt }), null);
    assert.equal(hook('Stop', { stop_hook_active: true, last_assistant_message: review }), null);
  }
});

test('normal completion consumes pending review and bypass cancels it', (t) => {
  const hook = hookFor(t);
  hook('UserPromptSubmit', { prompt: 'Do the work.' });
  assert.equal(hook('Stop', { stop_hook_active: true, last_assistant_message: 'Work completed.' }), null);
  assert.equal(hook('Stop', { stop_hook_active: true, last_assistant_message: review }), null);

  for (const prompt of ['/raw Do the work.', '[NO_REFINE] Do the work.']) {
    hook('UserPromptSubmit', { prompt: 'Do the work.' });
    assert.equal(hook('UserPromptSubmit', { prompt }), null);
    assert.equal(hook('Stop', { stop_hook_active: true, last_assistant_message: review }), null);
  }
});

test('pending continuation is isolated by session and turn', (t) => {
  const hook = hookFor(t);
  hook('UserPromptSubmit', { prompt: 'Do the work.' });
  const stop = { stop_hook_active: true, last_assistant_message: review };
  assert.equal(hook('Stop', { ...stop, session_id: 'other-session' }), null);
  assert.equal(hook('Stop', { ...stop, turn_id: 'other-turn' }), null);
  assert.deepEqual(hook('Stop', stop), continuation);
});

test('session-only goal review retains its initial continuation and loop guard', (t) => {
  const hook = hookFor(t);
  hook('SessionStart');
  assert.deepEqual(hook('Stop', { stop_hook_active: false, last_assistant_message: review }), continuation);
  assert.equal(hook('Stop', { stop_hook_active: true, last_assistant_message: review }), null);
});

test('legacy review marker can continue a new mid-turn request', (t) => {
  const hook = hookFor(t);
  hook('UserPromptSubmit', { prompt: 'Do the work.' });
  const stop = { stop_hook_active: true, last_assistant_message: '<!-- PROMPT_REVIEW_READY -->\n\nDo the work.' };
  const result = hook('Stop', stop);
  assert.equal(result?.decision, 'block');
  assert.ok(result.reason.startsWith('[PROMPT_REVIEW_EXECUTE]\n'));
  assert.equal(hook('Stop', stop), null);
});
