#!/usr/bin/env bash
set -euo pipefail

# SessionStart(compact) hook: inject framework reminder after context compaction
# Input: JSON via $1 or stdin with .source field

INPUT=""
if [ -n "${1:-}" ]; then
  INPUT="$1"
else
  INPUT=$(cat)
fi

# Detect source with jq, fallback to grep
if command -v jq &>/dev/null; then
  SOURCE=$(echo "$INPUT" | jq -r '.source // empty' 2>/dev/null)
else
  if echo "$INPUT" | grep -q '"source".*"compact"' 2>/dev/null; then
    SOURCE="compact"
  else
    SOURCE=""
  fi
fi

if [ "$SOURCE" != "compact" ]; then
  exit 0
fi

cat <<'CONTEXT'
<framework-reminder>
AGENTS 框架活跃中。核心规则：
- 技能路由：按 AGENTS.md 路由表匹配（github > fix-bug > develop-feature > refactor > review-code > architecture-review > commit-message > handoff > answer > loop-until-done）
- 退出标准：请求回看 → 产出物回读 → 验证证据（代码变更额外：测试 + 无回归 + diff 自审 + 五维质量门禁）
- 角色视角：内部激活适用视角，仅输出综合结论
- 语言：开发者内容中文、对外内容英文
- 输出：简洁直接，请求忠实度优先
请检查 auto-memory 获取当前任务上下文。
</framework-reminder>
CONTEXT

exit 0
