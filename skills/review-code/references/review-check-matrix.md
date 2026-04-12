# Review Check Matrix

本文件为 `skills/review-code/SKILL.md` 的按需参考，不是默认必须加载的主文档。

目标：

- 给 `review-code` 提供更细的 artifact-type 检查矩阵
- 明确 `Critical / Important / Suggestion` 的边界
- 明确证据不足时如何降级结论，而不是制造虚假确定性

## 1. Base Questions

所有评审对象默认先回答四个问题：

1. `目标是否达成`
- 评审对象是否满足已知目标、验收或最小使用场景

2. `实现是否正确`
- 是否存在错误假设、明显逻辑错误、边界遗漏、状态处理问题

3. `验证是否充分`
- 是否有足够证据支撑当前结论
- 是否存在缺失的测试、构建、手工验证、日志或需求依据

4. `交付是否可用`
- 即使短期能工作，是否会明显伤害维护、运行、回滚、支持或后续协作

若其中任一问题无法被低成本回答，应在结论中显式披露 `evidence gap` 或升级为更保守的 verdict。

## 2. Artifact-Type Matrix

### 2.1 Code

最小检查项：

- 正确性与行为回归
- 外部输入与错误路径
- 权限、归属、敏感数据访问
- 接口、状态、时序与副作用
- 复杂度、耦合与可维护性
- 验证记录是否足够

典型 `Critical`：

- 明显功能错误
- 安全漏洞
- 未处理的高风险失败路径
- 破坏兼容性却无说明
- 缺少关键验证且风险不可接受

典型 `Important`：

- 回归风险高但证据不足
- 复杂度明显上升
- 测试覆盖不匹配风险等级
- 命名、边界或职责已影响理解成本

### 2.2 Script

最小检查项：

- 参数、路径、环境变量校验
- 删除、覆盖、批量修改等危险动作保护
- 错误退出与半完成状态
- 幂等性或重复执行影响
- 日志、摘要与恢复路径

典型 `Critical`：

- 危险命令无保护
- 参数未转义导致注入风险
- 覆盖或删除行为缺少确认、备份或回滚说明
- 失败后继续执行造成脏状态

### 2.3 Documentation

最小检查项：

- 文档类型与受众是否清楚
- 事实、命令、路径、步骤是否与当前实现一致
- 是否混写教程、参考、设计、运维步骤
- 是否存在过时信息或误导性描述

典型 `Critical`：

- 指导步骤会直接导致错误操作
- 关键命令、路径、权限说明错误
- 文档宣称与真实实现冲突且足以误导执行

### 2.4 Rules / Skills / Prompts / Agent Behavior

只在命中时启用，不应成为普通代码评审的默认重心。

最小检查项：

- 是否与 `AGENTS.md`、上位规则或现有 lane 冲突
- 是否把下位流程硬塞进稳定宪法层文件
- 是否引入平台绑定、不可验证或高漂移约束
- 是否导致路由失真、角色冲突或虚假完成态
- 是否提高误用概率或无谓增加 token 成本

典型 `Critical`：

- 规则冲突导致行为不可预测
- 指令要求与验证能力不一致
- 把不可执行的强约束写成 hard gate
- 把仓库特性误写成全局通用规则

### 2.5 PRD / Test Cases

只在命中时启用。

最小检查项：

- 目标、范围、非目标是否清楚
- 验收是否可验证
- traceability 是否清楚
- 是否混入实现导向描述

## 3. Severity Guidance

### `Critical`

满足任一条件可视为 `Critical`：

- 会阻断合并、发布或可信交付
- 影响正确性、安全性、可靠性或关键可维护性基线
- 当前证据不足以支持放行

### `Important`

满足以下情形通常视为 `Important`：

- 不立即阻断，但当前轮修正成本低且收益高
- 若放过，会显著增加后续维护、排障或回归成本
- 风险已出现，但尚未到 blocker 级别

### `Suggestion`

仅用于：

- 风格、局部清晰度、非关键优化
- 明显有益但不影响当前放行判断的改进

禁止把 `Suggestion` 伪装成 blocker，也禁止把 blocker 降级成 suggestion 来避免冲突。

## 4. Evidence Downgrade Rules

### 可以继续评审，但必须降级结论的情况

- 只有 diff，没有需求或验收上下文
- 有代码，没有测试、构建或运行证据
- 只能看到局部文件，无法判断跨模块影响
- 变更过大，review unit 不合理

建议动作：

- 优先使用 `Comment + CONDITIONAL PASS` 或 `Request Changes + FAIL`
- 明确写出证据缺口，不要写“未发现问题，因此可合并”

### 应直接要求拆分或补证据的情况

- diff 体量明显过大，无法在合理上下文中完成可信 review
- 变更缠结多个主题，无法建立清晰风险边界
- 高风险改动完全没有验证记录
- 文件或补丁内容不完整，关键上下文缺失

## 5. Finding Template

推荐模板：

```markdown
- [path/to/file.ext:line] Critical
  Issue: <what is wrong>
  Why: <why it matters>
  Evidence: <file / diff / command / output / requirement mismatch>
  Fix: <smallest practical correction>
```

要求：

- 一条 finding 只表达一个主问题
- 优先给最小修复建议，不写大而空的重构宣言
- 若证据来自推断而非直接观察，必须显式标注推断边界

## 6. Review Output Discipline

- 先给 findings，再给 open questions 和 verdict
- 默认按严重度排序，不按阅读顺序堆砌
- 小改动默认先输出最有价值的前几个问题
- 无 blocker 时，也要披露验证边界和残余风险
