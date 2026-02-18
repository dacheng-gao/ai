#!/usr/bin/env bash
set -euo pipefail

# SessionStart(startup) hook: detect HANDOFF.md and prompt recovery

HANDOFF_PATHS=(
  ".claude/HANDOFF.md"
  "HANDOFF.md"
)

FOUND=""
for path in "${HANDOFF_PATHS[@]}"; do
  if [ -f "$path" ]; then
    FOUND="$path"
    break
  fi
done

if [ -z "$FOUND" ]; then
  exit 0
fi

cat <<EOF
<session-recovery>
检测到交接文档：${FOUND}
上一个会话留下了未完成的工作上下文。建议询问用户是否需要恢复并继续。
</session-recovery>
EOF

exit 0
