# Superagents Routing Matrix

在 `superagents` 已被触发后，使用本文件完成更细的 `lane + depth` 裁决。

## Lane Selection

| User intent / signal | Internal lane | Required process skill | Notes |
|----------------------|---------------|------------------------|-------|
| 解释代码、技术概念、输出命令、轻量查阅 | `answer` | none beyond `using-superpowers` | 默认本地完成 |
| Git 本地操作、提交、分支、差异处理 | `git` | none beyond `using-superpowers` | 若涉及提交规则，按仓库 `skills/git` 执行 |
| GitHub issue / PR / release / remote context | `github` | none beyond `using-superpowers` | 需要远程上下文时优先一手来源 |
| 跨会话续跑、状态交接、上下文压缩 | `handoff` | none beyond `using-superpowers` | 以可恢复性为第一目标 |
| 缺陷、回归、崩溃、错误结果、性能退化 | `fix-bug` | `systematic-debugging` -> `test-driven-development` -> `verification-before-completion` | 先复现再修 |
| 新功能、集成、行为新增、数据模型变更 | `develop-feature` | `test-driven-development` -> `verification-before-completion` | 需求不清时先 `brainstorming` |
| 保行为的结构调整、性能优化、边界重划 | `refactor` | `test-driven-development` -> `verification-before-completion` | 禁止借机扩 scope |
| 代码评审、PR 审查、diff 评估 | `review-code` | `requesting-code-review` or `receiving-code-review` | 输出以 findings 为主 |
| 架构、平台、系统设计、治理规则评估 | `architecture-review` | `requesting-code-review` when applicable | 需要显式 trade-off |
| 无法稳定分类、存在多个合理路径 | research -> planning | `brainstorming` when threshold met | 先收敛再进入明确 lane |

## Depth Selection

### Lite

仅在满足全部条件时允许：
- 命中 `rules/fast-path.md`
- 单点、低风险、可局部验证
- 不涉及安全、规则、Prompt、架构边界或复杂并发
- 不需要多角色显式评审

推荐路径：
- route -> execute -> report

最小验证：
- 请求对照
- 命令/语法检查或文档回读
- 相关 diff 自审

### Standard

默认档位。满足任一项通常进入 `Standard`：
- 常规 feature / bug / refactor / review
- 跨多个文件或模块
- 需要计划、评审或验证闭环
- 修改 `rules / skills / prompts / AGENTS.md / CLAUDE.md`

标准路径：
- research -> plan -> implement -> review -> verify -> report

标准验证：
- 按适用性执行 `Typecheck / Build -> Lint / Static Analysis -> Test -> Manual Verification`

### Full

满足任一项则优先考虑升级：
- 安全、鉴权、敏感数据、外部暴露
- 生产事故、高影响修复、迁移、发布、回滚
- 跨模块复杂并发，且文件边界可清晰切分
- 存在真实多方案权衡，错误决策代价高
- 需要并行研究、双评审或更强审计轨迹

完整路径：
- parallel-research -> plan -> parallel-implement -> dual-review -> full-verify -> report

附加要求：
- 只在文件所有权清晰时并发写入
- 至少一次显式风险披露
- 对牺牲项与残余风险做裁决说明

## Brainstorming Trigger

命中任一项就切换到 `superpowers:brainstorming`：
- 目标本身模糊，无法判断真实完成条件
- 至少两个方案都合理，且 trade-off 真实存在
- 跨模块边界或职责划分不清晰
- 用户明确要求先讨论设计、方案或方向
- 疑似 `XY` 问题，当前路径不是最低成本解

不要因为以下情况就升级到 `brainstorming`：
- 只缺一个参数
- 单文件低风险修改，且实现路径唯一
- 纯执行型 Git / GitHub / answer 请求

## Rules / Prompt / Skill Changes

当任务触及以下文件时，`Lite` 默认失效：
- `AGENTS.md`
- `CLAUDE.md`
- `rules/*.md`
- `skills/*/SKILL.md`
- 任何改变 Agent 行为的模板或 Prompt 文件

此类任务至少要做到：
- `depth >= Standard`
- 显式纳入 `Prompt / Agent Behavior` 视角
- 在交付前读取 `references/verification-evals.md`

## Route Decision Record

在中间更新或最终汇报中，至少留下：

```text
route: superagents
lane: <lane>
depth: Lite | Standard | Full
reason:
- <为什么是这个 lane>
- <为什么是这个 depth>
evidence:
- <关键词 / file:line / command summary / user explicit intent>
next:
- <下一步动作>
```
