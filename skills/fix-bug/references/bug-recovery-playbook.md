# Bug Recovery Playbook

## Purpose

本文件用于指导 `fix-bug` 在根因已明确后，如何选择最小风险的恢复路径并保持范围收敛。

## Bug Classes

### `crash`

- 进程崩溃、未捕获异常、核心路径直接中断
- 优先确认触发条件、错误边界和是否需要先止血

### `regression`

- 过去正常、现在失败
- 优先检查近期变更、契约变化和隐藏依赖

### `incorrect-output`

- 返回值、页面结果、状态变化或副作用错误
- 优先区分计算错误、数据错误、时序错误和权限错误

### `performance`

- 延迟、吞吐、资源占用明显退化
- 优先确认退化是否可重复、影响面多大、是否有热点路径

### `integration-or-environment`

- 外部系统、配置、部署环境、凭证、网络或第三方交互失败
- 优先识别问题在边界哪一侧

### `data-consistency`

- 数据错乱、丢失、重复、迁移不一致、状态不收敛
- 优先确认影响范围、可恢复性和回滚代价

## Recovery Modes

### `mitigation`

- 先降低影响，未必解决根因
- 适用于高影响场景下的临时保护

### `workaround`

- 绕开触发路径，让系统先恢复可用
- 不是根治，必须显式标注

### `rollback`

- 撤回导致问题的近期变化
- 适用于根因明确且回退成本低于继续修复

### `root-cause-fix`

- 直接修复导致问题的真实原因
- 默认优先目标，但前提是根因已确认

## Scope Control

- 只修与当前 bug 直接相关的层和边界
- 默认不顺手做重构、性能优化或 feature 扩展
- 若必须扩大范围，必须说明为何当前范围不足以安全修复
- 对 data consistency、auth、migration 类问题，优先保守处理，避免二次伤害

## Third-Party Cases

当根因在第三方依赖、外部服务或上游系统时：

- 明确标出责任边界
- 优先给出可执行 workaround 或 mitigation
- 记录上游 issue、版本或外部限制
- 不要把无法控制的部分伪装成“本地已彻底修复”

## Failure Handling

### 修复后仍失败

- 明确失败的是哪条验证
- 不要在原修复上继续叠加多个补丁
- 回到调查阶段，重新评估根因

### rollback 仍无法恢复

- 明确说明 rollback 失败的原因
- 重新识别当前系统状态，而不是假设已回到安全点

### workaround 产生代价

- 明确写出牺牲项、限制条件和后续清理需求

## Reporting Reminders

- `mitigation / workaround / rollback / root-cause-fix` 必须区分
- 不能把“影响变小了”写成“问题已彻底修复”
- 不能省略对残余风险和后续动作的说明
