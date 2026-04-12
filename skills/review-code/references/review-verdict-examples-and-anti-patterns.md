# Review Verdict Examples And Anti-Patterns

本文件为 `skills/review-code/SKILL.md` 的按需参考，用于快速校准：

- verdict 该怎么下
- finding 该怎么写
- 哪些写法看似专业，实际会误导用户

它不替代 `review-check-matrix.md`，也不提供完整模板库。

## 1. Verdict Examples

### Example 1: `Approve + PASS`

Context:

- 小范围代码改动
- 行为目标清楚
- 有对应测试或等价验证
- 未发现阻断问题

Good Verdict:

```markdown
Findings
- 未发现阻断问题。

Open Questions
- 无。

Review Action
- Approve

Quality Result
- PASS

Evidence
- 变更范围局部，相关测试已覆盖，未见回归风险信号。

Risks / Gaps
- 无明显阻断风险。
```

Why it is correct:

- 结论与证据强度一致
- 没有把“没意见”写成空话
- 仍然保留了 evidence 和 risk 字段

### Example 2: `Comment + CONDITIONAL PASS` because of evidence gap

Context:

- diff 本身基本合理
- 但缺少测试、构建或运行证据
- 当前看不到 blocker

Good Verdict:

```markdown
Findings
- [src/foo.ts:42] Important
  Issue: 当前改动改变了错误分支，但未附带对应验证记录。
  Why: 在缺少验证时，无法确认失败路径与旧行为是否一致。
  Evidence: diff 显示错误处理分支已调整，但未提供测试或运行结果。
  Fix: 补充覆盖该失败路径的测试，或提供等价手动验证记录。

Open Questions
- 该失败路径是否已有仓库外验证记录？

Review Action
- Comment

Quality Result
- CONDITIONAL PASS
```

Why it is correct:

- 没把证据缺口误写成 blocker
- 也没有把“看起来没问题”升级成 `PASS`

### Example 3: `Request Changes + FAIL` for correctness issue

Context:

- 有明确逻辑错误
- 会影响核心行为

Good Verdict:

```markdown
Findings
- [src/order.ts:118] Critical
  Issue: 退款分支在金额为零时提前返回，导致后续状态更新不会执行。
  Why: 这会让订单状态与真实退款结果不一致。
  Evidence: 当前控制流在 `amount === 0` 时直接 `return`，跳过了状态写入。
  Fix: 将状态更新从金额判断中解耦，确保零金额路径仍完成状态同步。

Review Action
- Request Changes

Quality Result
- FAIL
```

Why it is correct:

- blocker、影响和修法都说清楚了
- verdict 与 finding 严重度一致

### Example 4: Large or tangled diff should not get fake certainty

Context:

- 变更跨多个主题
- review unit 过大

Good Verdict:

```markdown
Findings
- Important
  Issue: 本次变更同时包含行为修改、重命名和文档更新，review unit 过大。
  Why: 当前上下文下无法建立清晰风险边界，评审结论可信度不足。
  Evidence: diff 同时覆盖多个目录与不同类型产物，且缺少拆分说明。
  Fix: 按行为变更、结构整理、文档更新拆分 review unit 后重新提交。

Review Action
- Request Changes

Quality Result
- FAIL
```

Why it is correct:

- 问题不一定在代码细节，而在 review 单元本身不可评
- 没有假装自己已经完成全面评审

### Example 5: Preference is not a blocker

Context:

- 实现可工作
- reviewer 只是更偏好另一种写法

Good Verdict:

```markdown
Findings
- Suggestion
  Issue: 这里可以考虑把条件分支提取成小函数，局部可读性会更高。
  Why: 目前实现仍可正确工作，这属于可选优化而非 blocker。
  Evidence: 当前逻辑可读但偏长，没有观察到错误行为。
  Fix: 若团队准备继续扩展该分支，可在后续重构时再拆分。

Review Action
- Approve

Quality Result
- PASS
```

Why it is correct:

- 明确把个人偏好降级为 `Suggestion`
- 没有拿风格偏好阻断合并

### Example 6: Rules / prompt change with behavior risk

Context:

- 评审对象是 `rules`、`skills` 或 prompt 文件
- 变更会影响 agent 行为

Good Verdict:

```markdown
Findings
- [skills/example/SKILL.md:34] Critical
  Issue: 新增 hard gate 要求“任何任务都必须先执行完整实现计划”，但当前仓库也允许 low-risk fast path。
  Why: 这会与现有路由规则冲突，导致简单任务被错误升级。
  Evidence: 新约束与现有 fast-path 规则不一致，行为裁决将出现冲突。
  Fix: 将该要求收敛到适用场景，或改为升级条件而非全局 hard gate。

Review Action
- Request Changes

Quality Result
- FAIL
```

Why it is correct:

- 命中了 agent 行为资产的专项检查
- 问题不是“文案不优雅”，而是行为约束冲突

### Example 7: Docs review with executable-path issue

Context:

- 评审对象是 runbook 或 SOP
- 命令、路径或权限说明错误

Good Verdict:

```markdown
Findings
- [docs/runbook.md:52] Critical
  Issue: 文档要求直接运行删除命令，但未说明前置目录与备份条件。
  Why: 读者按文档执行可能直接破坏生产数据。
  Evidence: 当前步骤缺少路径确认、备份或 dry-run 指导。
  Fix: 补充前置条件、目标路径确认和回滚说明。

Review Action
- Request Changes

Quality Result
- FAIL
```

Why it is correct:

- 文档评审也按可执行后果判断严重度
- 没把文档问题当成“低风险文字问题”

### Example 8: No blocker, but still disclose residual risk

Context:

- 改动整体可接受
- 但有合理的残余风险

Good Verdict:

```markdown
Findings
- 未发现阻断问题。

Open Questions
- 无。

Review Action
- Approve

Quality Result
- PASS

Evidence
- 变更局部，相关测试已覆盖。

Risks / Gaps
- 本次未看到高负载场景证据；若该路径后续变成热点，需补性能验证。
```

Why it is correct:

- `PASS` 不等于“没有任何未来风险”
- 披露残余风险不会削弱结论，反而让结论更可信

## 2. Anti-Patterns

### Anti-Pattern 1: No-evidence approval

Bad:

```markdown
代码看起来没问题，可以合并。
```

Why it is wrong:

- 没有范围
- 没有证据
- 没有风险边界

### Anti-Pattern 2: Preference dressed up as blocker

Bad:

```markdown
必须改成我更习惯的写法，否则不能过。
```

Why it is wrong:

- 把个人偏好伪装成质量门禁
- 没有说明 correctness、security 或 reliability 影响

### Anti-Pattern 3: Finding without impact

Bad:

```markdown
- [foo.ts:10] Important
  这里不太好。
```

Why it is wrong:

- 没说问题是什么
- 没说为什么重要
- 用户无法执行修复

### Anti-Pattern 4: Evidence gap written as certainty

Bad:

```markdown
虽然没有测试，但逻辑很简单，应该没问题。
```

Why it is wrong:

- 用推测替代验证
- 让用户误以为 reviewer 已确认正确性

### Anti-Pattern 5: Verdict and findings disagree

Bad:

```markdown
Findings
- [auth.ts:88] Critical
  ...

Review Action
- Approve
```

Why it is wrong:

- blocker 与 verdict 冲突
- 用户无法判断到底该不该放行

### Anti-Pattern 6: Review becomes rewrite plan

Bad:

```markdown
我建议把这一层整体重构成新的模块体系，再顺便统一日志、错误处理和权限框架。
```

Why it is wrong:

- 脱离当前评审范围
- 没有给最小可执行修复建议
- 把 review lane 污染成设计或实现 lane

### Anti-Pattern 7: Terse verdict with hidden scope

Bad:

```markdown
整体 OK。
```

Why it is wrong:

- 没说明评了什么
- 没说明没评什么
- 很容易制造虚假完成感

### Anti-Pattern 8: Comment noise flood

Bad:

```markdown
列出十几个风格建议，但真正的 blocker 被埋在中间。
```

Why it is wrong:

- 严重度排序失效
- 用户难以识别优先级
- 高价值结论被噪音淹没

## 3. Fast Self-Check

在给出 verdict 前，快速问自己：

1. findings 和 `Review Action / Quality Result` 是否一致
2. 我写的是证据，还是推测
3. 我指出的是 blocker，还是个人偏好
4. 我给的是最小修复建议，还是无边界重写
5. 我是否说明了评审范围和残余风险
