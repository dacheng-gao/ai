#!/usr/bin/env bash
set -euo pipefail

# SessionStart(compact) hook: remind to restore task context after compaction
# Triggered by settings.json matcher "compact" — no need to check source field

cat <<'CONTEXT'
<context-recovery>
上下文已压缩。请检查 TaskList 恢复当前任务进度。
</context-recovery>
CONTEXT

exit 0
