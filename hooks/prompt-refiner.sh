#!/usr/bin/env bash
set -euo pipefail

# UserPromptSubmit hook: Detect prompt clarity and inject refinement signals
# Clear prompts → no overhead; vague prompts → signal Claude to generate execution spec
#
# Input: JSON on stdin with .prompt field
# Output: JSON with additionalContext (or empty exit for clear prompts)

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

# === Early exits ===

# Empty prompt
if [ -z "$PROMPT" ]; then
  exit 0
fi

# Slash commands (/help, /commit, etc.)
if [[ "$PROMPT" == /* ]]; then
  exit 0
fi

# Single word confirmations (y/n/yes/no/ok/好/是/否/行)
if echo "$PROMPT" | grep -qxE '[ynYN]|yes|no|ok|好|是|否|行|确认|取消|继续'; then
  exit 0
fi

PROMPT_LEN=${#PROMPT}

# === Fast skip: already specific prompts ===

# Contains code blocks → developer is providing specific context
if echo "$PROMPT" | grep -q '```'; then
  exit 0
fi

# Very long prompts (>200 chars) → likely already detailed
if [ "$PROMPT_LEN" -gt 200 ]; then
  exit 0
fi

# Contains file path + action verb → specific enough
HAS_PATH=false
HAS_ACTION=false

EN_VERBS="fix|add|create|implement|update|delete|refactor|test|write|change|modify|remove|replace|migrate|upgrade|configure|setup|review|debug|optimize|build|deploy|move|rename|extract|split|merge"
CN_VERBS="修复|添加|创建|实现|更新|删除|重构|测试|写|改|加|去掉|迁移|升级|配置|修改|移除|替换|评审|调试|优化|构建|部署|移动|重命名|提取|拆分|合并"

if echo "$PROMPT" | grep -qE '[./][a-zA-Z0-9_/-]+\.[a-z]{1,5}' || \
   echo "$PROMPT" | grep -qiE '\b(src/|lib/|app/|pages/|components/|hooks/|agents/|rules/|skills/)'; then
  HAS_PATH=true
fi

if echo "$PROMPT" | grep -qiE "\b($EN_VERBS)\b" || \
   echo "$PROMPT" | grep -qE "($CN_VERBS)"; then
  HAS_ACTION=true
fi

if [ "$HAS_PATH" = true ] && [ "$HAS_ACTION" = true ]; then
  exit 0
fi

# === Clarity scoring (0-100, higher = less clear) ===
SCORE=0

# Short prompts lack context
if [ "$PROMPT_LEN" -lt 10 ]; then
  SCORE=$((SCORE + 35))
elif [ "$PROMPT_LEN" -lt 25 ]; then
  SCORE=$((SCORE + 15))
fi

# No action verb (EN or CN)
if [ "$HAS_ACTION" = false ]; then
  SCORE=$((SCORE + 25))
fi

# Vague/casual words (EN + CN)
EN_VAGUE="something|somehow|maybe|just|simply|stuff|things|anything|whatever"
CN_VAGUE="那个|这个|什么的|差不多|随便|搞一下|弄一下|处理一下|看看|帮我|整一下|搞搞"
if echo "$PROMPT" | grep -qiE "\b($EN_VAGUE)\b" || \
   echo "$PROMPT" | grep -qE "($CN_VAGUE)"; then
  SCORE=$((SCORE + 20))
fi

# No specific object reference (EN + CN)
# Split file-extension check (no \b before dot) from word-boundary checks
HAS_OBJECT=false
if echo "$PROMPT" | grep -qE '\.[a-z]{1,5}\b'; then
  HAS_OBJECT=true
elif echo "$PROMPT" | grep -qiE '\b(src/|lib/|app/|hooks/|agents/|component|module|file|class|function|api|endpoint|route|model|schema|database|table|config|hook|rule|skill)\b'; then
  HAS_OBJECT=true
elif echo "$PROMPT" | grep -qE '(文件|模块|组件|接口|函数|类|路由|模型|表|数据库|页面|端点|配置|钩子|规则|技能)'; then
  HAS_OBJECT=true
fi
if [ "$HAS_OBJECT" = false ]; then
  SCORE=$((SCORE + 15))
fi

# Question-only without action context
if echo "$PROMPT" | grep -qiE '^(how|what|why|when|where|can|could|would|is|are|do|does)' && [ "$PROMPT_LEN" -lt 50 ]; then
  SCORE=$((SCORE + 10))
fi
if echo "$PROMPT" | grep -qE '^(为什么|怎么|什么|哪|如何|是不是|能不能|可以)' && [ "$PROMPT_LEN" -lt 50 ]; then
  SCORE=$((SCORE + 10))
fi

# === Output based on clarity level ===

if [ "$SCORE" -le 20 ]; then
  # Clear — no injection, zero overhead
  exit 0

elif [ "$SCORE" -le 45 ]; then
  # Moderate — inject workspace context to help Claude infer intent
  BRANCH=$(git branch --show-current 2>/dev/null || echo "n/a")
  CHANGES=$(git diff --name-only 2>/dev/null | head -5 | tr '\n' ', ' || echo "none")
  STAGED=$(git diff --cached --name-only 2>/dev/null | head -5 | tr '\n' ', ' || echo "none")
  RECENT=$(git log --oneline -3 2>/dev/null | tr '\n' '; ' || echo "none")

  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "<workspace-context>\nBranch: ${BRANCH}\nModified: ${CHANGES:-none}\nStaged: ${STAGED:-none}\nRecent commits: ${RECENT:-none}\n</workspace-context>"
  }
}
EOF
  exit 0

else
  # Vague — signal Claude to run intent review and generate execution spec
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "<refine-prompt>用户请求较模糊（清晰度: ${SCORE}）。执行 Prompt Review：\n1. 快速扫描代码库（Glob/Grep ≤3 次）识别相关文件和上下文\n2. 推断用户意图\n3. 生成结构化执行方案（含目标/范围/行为规格/验收标准）\n4. 输出方案给用户确认或修改，确认后再执行\n\n如分析后判断请求已足够明确，可跳过方案生成直接执行。</refine-prompt>"
  }
}
EOF
  exit 0
fi
