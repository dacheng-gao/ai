# 通用工程任务提示词模板（Superagents × Superpowers）

将领域专用 prompt 抽象为复用模板，适用于 bug 修复、功能开发、重构、协议/行为对齐、性能治理等复杂任务。

## 适用条件
- 任务跨模块、跨角色或需要并行执行
- 目标包含“外部行为不回归”约束
- 需要多轮实现与验证收敛

## 占位符字典

| 占位符 | 含义 |
|---|---|
| `<agent_role>` | 角色（master/planner/implementer/reviewer/verifier/reporter） |
| `<task_category>` | 类型（bug/feature/refactor/review） |
| `<required_superpowers>` | 必选 Superpowers（按顺序） |
| `<external_behavior_contract>` | 必须保持不变的外部行为边界 |
| `<target_system>` | 目标系统/模块 |
| `<reference_baseline>` | 对照基线（实现/规范/协议） |
| `<reference_path>` | 对照基线路径或链接 |
| `<module_scope>` | 分析与改动范围 |
| `<consistency_dimensions>` | 一致性维度（行为/API/协议/数据语义等） |
| `<out_of_scope>` | 明确不做范围 |
| `<agent_topology>` | 多 Agent 拓扑（如 1 master + 3 workers） |
| `<parallel_boundaries>` | 并行边界（文件所有权、禁止并行写同文件） |
| `<hot_paths>` | 性能热点路径 |
| `<platform_optimized_techniques>` | 平台适配低开销优化策略 |
| `<targeted_tests>` | 针对性测试集合 |
| `<typecheck_or_build_command>` | 类型检查或构建命令 |
| `<lint_command>` | lint 命令 |
| `<test_command>` | 测试命令 |
| `<build_command>` | 构建命令（可选） |
| `<stop_condition>` | 收敛停止条件 |
| `<evidence_artifacts>` | 证据形式（命令摘要、日志、`file:line` 等） |

## 可复用模板

```text
以本仓库的 `<agent_role>` 身份工作。

先执行路由：`superpowers:using-superpowers`。
任务类型：`<task_category>`。
本任务必选 Superpowers：`<required_superpowers>`。

目标：
在不改变 `<external_behavior_contract>` 的前提下，对 `<target_system>` 执行任务，
并与 `<reference_baseline>`（`<reference_path>`）尽量对齐，同时提升正确性、安全性、性能与可维护性。

范围与边界：
- 范围：`<module_scope>`
- 不做：`<out_of_scope>`
- 团队拓扑：`<agent_topology>`
- 并行边界：`<parallel_boundaries>`

执行规则：
1. 先对照 `<reference_baseline>` 的 `<module_scope>`，找出 `<consistency_dimensions>` 差距，再实施修改。
2. 按优先级推进：正确性 > 安全性 > 性能 > 可维护性。
3. 仅做外科手术式改动：最小必要修改，不触碰 `<out_of_scope>`，不回滚无关本地改动。
4. 在 `<hot_paths>` 优先采用 `<platform_optimized_techniques>`，避免不必要分配与拷贝。
5. 若任务包含行为变更，每个关键改动都补充或更新 `<targeted_tests>`（主路径/边界/异常路径）。
6. 每完成一批关键改动，按顺序执行 `<typecheck_or_build_command>` → `<lint_command>` → `<test_command>`（按适用性执行）。
7. 验证失败则回到对应阶段修复，最多迭代 3 轮。
8. 声称“完成/通过”前，必须满足 `superpowers:verification-before-completion`。
9. 持续迭代直到 `<stop_condition>` 达成后再收敛。

输出要求：
- status: success|partial|failed|blocked
- 请求对照：Done/Partial/Skipped
- 关键改动：文件 + 行为影响
- 验证证据：完整命令 + 结果摘要
- 残余风险：未完成项、影响范围、回滚建议（如有）
- 证据格式：`<evidence_artifacts>`
```

## 使用步骤
1. 用真实项目数据替换占位符，先明确 `<external_behavior_contract>` 与 `<out_of_scope>`
2. 按任务类型填写 `<required_superpowers>`
   - `bug`: `systematic-debugging -> test-driven-development -> verification-before-completion`
   - `feature/refactor`: `test-driven-development -> verification-before-completion`
   - `review`: `requesting-code-review/receiving-code-review`
3. 绑定真实验证命令：`<typecheck_or_build_command>`、`<lint_command>`、`<test_command>`
4. 将替换后的模板作为 planner/implementer/reviewer/verifier/reporter 的共享输入，统一验收口径
