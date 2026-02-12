#!/usr/bin/env bash
set -euo pipefail

cat <<'PROMPT'
<context-preservation>
上下文即将压缩。执行以下保存操作：

1. **TaskList 快照**：如有活跃 task，用 TaskList 确认当前进度
2. **Memory 写入**（按分类写入对应文件）：
   - `MEMORY.md`：项目概要、用户偏好（仅索引，≤200 行）
   - `patterns.md`：本次发现的可复用代码模式或架构约定
   - `decisions.md`：本次做出的关键技术决策与理由
   - `debugging.md`：本次解决的非显然问题与方案
3. **跳过条件**：简单问答或已完成任务且无新知识 → 跳过

仅写入跨会话有价值的已验证信息，不写入当前会话临时状态。
</context-preservation>
PROMPT

exit 0
