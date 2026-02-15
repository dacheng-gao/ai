#!/usr/bin/env bash
set -euo pipefail

# PreToolUse(Write|Edit) hook: block sensitive files, warn on uncommitted changes
# Input: JSON on stdin with tool_input.file_path

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
  echo '{}'
  exit 0
fi

BASENAME=$(basename "$FILE_PATH")

# Sensitive file hard block (exit 2)
case "$BASENAME" in
  .env|.env.*)
    echo "BLOCKED: refusing to modify sensitive file: $FILE_PATH" >&2
    exit 2
    ;;
  *.pem|*.key)
    echo "BLOCKED: refusing to modify sensitive file: $FILE_PATH" >&2
    exit 2
    ;;
esac

case "$FILE_PATH" in
  *credentials*|*/credentials/*)
    echo "BLOCKED: refusing to modify sensitive file: $FILE_PATH" >&2
    exit 2
    ;;
esac

# New file — allow without git check
if [ ! -f "$FILE_PATH" ]; then
  echo '{}'
  exit 0
fi

# Check if file has uncommitted changes in git
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')
cd "$CWD" 2>/dev/null || cd "$(dirname "$FILE_PATH")" 2>/dev/null || exit 0

if git rev-parse --is-inside-work-tree &>/dev/null; then
  STATUS=$(git status --porcelain -- "$FILE_PATH" 2>/dev/null || true)
  if [ -n "$STATUS" ]; then
    cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "WARNING: $FILE_PATH has uncommitted git changes. Overwriting will lose those changes. Consider committing or stashing first."
  }
}
EOF
    exit 0
  fi
fi

echo '{}'
exit 0
