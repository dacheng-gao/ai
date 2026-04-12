# Debugging Escalation Playbook

## Purpose

本文件用于定义 `fix-bug` 在不同调查状态下允许做什么、不能做什么，以及何时必须升级路径。

它补充 `superpowers:systematic-debugging`，但不替代其调查方法论。

## Investigation States

### `unreproduced`

特征：

- 现象已知，但无法稳定复现
- 只有零散日志、报错、用户反馈或测试失败片段

当前重点：

- 收集最小证据面
- 确认环境、输入、时序与近期变化
- 建立可重复的观察方式

### `reproduced-no-root-cause`

特征：

- 问题可复现
- 但还不能确定根因

当前重点：

- 缩小故障边界
- 追踪数据流、组件边界、依赖条件
- 排除错误假设

### `single-high-confidence-hypothesis`

特征：

- 已形成一个最可能假设
- 但证据仍不足以把它写成已确认根因

当前重点：

- 做最小实验验证
- 防止多个变量一起变动

### `root-cause-confirmed`

特征：

- 已能解释问题现象
- 证据与现象一致
- 可明确指出应修哪一层

当前重点：

- 进入最小修复
- 准备覆盖根因的验证

## Escalation Triggers

出现以下情况时，必须升级，而不是继续顺手修：

- 长时间无法复现
- 多个候选根因都能部分解释现象
- 新证据与当前假设冲突
- 已尝试多次修复仍失败
- 每次修复都暴露出新的共享状态、耦合或时序问题
- 问题更像架构或设计缺陷，而不是单点错误

## Allowed Actions By State

### `unreproduced`

允许：

- 收集日志、错误信息、环境差异
- 加最小诊断信息
- 请求缺失输入
- 定义 workaround 或 mitigation，但必须明确标识

不允许：

- 宣称根因已确认
- 宣称 bug 已修复
- 直接提交正式修复结论

### `reproduced-no-root-cause`

允许：

- 追踪数据流
- 对比工作正常的参考路径
- 做最小调查实验

不允许：

- 把最顺眼的现象当根因
- 多个改动一起试

### `single-high-confidence-hypothesis`

允许：

- 做单变量验证
- 为正式修复准备测试保护

不允许：

- 在未验证前把假设写成结论

### `root-cause-confirmed`

允许：

- 进入 TDD 修复
- 选择正式修复、回滚、workaround 或 mitigation

不允许：

- 顺手把问题升级成无关重构

## Architecture Suspicion Signals

出现以下信号时，应怀疑路径本身有问题：

- 3 次以上修复失败
- 每次修复都在不同模块暴露新问题
- 修复需要大面积重构才能成立
- 根因表现为系统性边界模糊、共享状态污染、时序不稳定或职责错位

此时应停止继续 patch，并升级到架构或设计层面讨论。

## Recovery Path

### 证据不足

- 回到 `unreproduced` 或 `reproduced-no-root-cause`
- 明确写出缺什么证据
- 请求补充环境、日志、步骤或样本

### 假设失败

- 丢弃当前假设，不叠加更多修复
- 用新信息重新进入调查

### 多次失败

- 停止继续补丁式推进
- 报告当前证据、失败尝试与架构怀疑点
- 升级到更高层方案判断
