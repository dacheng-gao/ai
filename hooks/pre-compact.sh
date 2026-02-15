#!/usr/bin/env bash
set -euo pipefail

cat <<'PROMPT'
<context-preservation>
上下文即将压缩。如有活跃 task，用 TaskList 确认当前进度。
</context-preservation>
PROMPT

exit 0
