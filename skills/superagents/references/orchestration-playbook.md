# Superagents Orchestration Playbook

在已经确定 `lane + depth` 后，使用本文件约束具体执行方式。

## Core Workflow

### Lite

1. 回显任务理解
2. 直接执行最小动作
3. 做最小验证
4. 汇报结果、证据、风险

### Standard

1. Research
   - 收集本地上下文
   - 需要外部资料时优先一手来源
2. Plan
   - 输出 `目标 / 范围 / 不做 / 验收`
   - 只选择必要 Skills 和角色
3. Implement / Review
   - 实施与自检成对出现
   - 不顺手扩大改动范围
4. Verify
   - 先基础校验，再质量校验，再行为验证
5. Report
   - 按 `直接执行 / 深度交互` 输出

### Full

1. Parallel research
2. Plan with ownership
3. Parallel implement on disjoint write sets
4. Dual review
5. Full verify
6. Risk-aware report

只有在真正需要并发、且文件边界清晰时才使用 `Full`。

## Opening Alignment Contract

在实现前，先向用户回显：
- `目标`
- `范围`
- `不做`
- `关键假设`
- `验收`

推荐固定字段：

```text
refined_request:
intent_summary:
scope:
out_of_scope:
assumptions:
open_questions:
proceed: yes | wait_for_user
```

仅在以下情况停下提问：
- 缺少关键输入
- 需要业务裁决
- 存在真实多方案权衡
- 目标模糊或疑似 `XY`

## Minimal Role Set

默认只启用最少但足够的角色集合：

| Task type | Minimum roles |
|-----------|---------------|
| answer / git / github / handoff | `researcher` + `reporter` |
| fix-bug | `researcher` + `implementer` + `reviewer` + `verifier` + `reporter` |
| develop-feature / refactor | `researcher` + `planner` + `implementer` + `reviewer` + `verifier` + `reporter` |
| review-code / architecture-review | `reviewer` + `reporter` |
| rules / prompts / skill behavior changes | `planner` + `reviewer` + `verifier` + `reporter` |

若任务涉及安全、隐私、外部暴露或权限边界，再补 `security-auditor` 视角。

## Parallelism Rules

- 默认不并发写文件
- 只有在写入集合互不重叠时才启用多个 implementer
- 小任务或高冲突任务维持串行
- 并发时必须显式声明文件所有权

## Conflict Resolution

当角色或目标冲突时，按以下优先级裁决：

1. 安全 / 隐私
2. 正确性 / 事实性
3. 用户真实目标
4. 可验证性与恢复性
5. 可维护性 / 可运维性
6. 速度 / 成本 / 优雅性

对外汇报时要说清：
- `Conflict`
- `Decision`
- `Why`
- `What was sacrificed`
- `Residual risk`

## Degradation Paths

| Missing capability | Fallback |
|--------------------|----------|
| `brainstorming` | 快速扫描 + 一次性关键问题澄清 + 方案确认 |
| `systematic-debugging` | 复现 -> 证据收集 -> 根因假设 -> 最小改动验证 |
| `test-driven-development` | 先补失败用例，再做实现，保留红绿证据 |
| `verification-before-completion` | 手动执行基础校验 -> 质量校验 -> 行为验证 |
| 并行 agent 不可用 | 主 agent 手动切分任务，保持文件边界互斥 |

## Anti-Patterns

- 用 `superagents` 代替具体 lane skill，而不是路由到它
- 因为想“看起来完整”而加载过多参考文件
- 把用户已明确的简单请求强行升级为复杂计划
- 把 `depth` 当作能力炫技，而不是风险控制
- 无证据完成、无裁决交付、无边界并发
