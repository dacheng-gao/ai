# Superagents Verification And Evals

在声称 `superagents` 路由正确、编排可用或修改后的 skill 已达可交付状态前，至少检查以下四类证据。

## 1. Metadata Audit

检查 `SKILL.md` frontmatter 是否满足：
- 只使用支持的字段
- `description` 同时说明做什么与何时触发
- 没有把完整 workflow 塞进 `description`
- 关键检索词覆盖主要 lane 与触发场景

## 2. Progressive Disclosure Audit

检查主文件是否只保留：
- 触发条件
- 硬约束
- 核心工作环
- 参考文件装载地图

以下内容应放到按需文件而不是主文件：
- 完整路由矩阵
- 角色拓扑与并发细则
- 长模板
- 评测场景与验证细则

## 3. Route Scenario Checks

至少用以下场景做走读，确认 `lane + depth` 判定稳定：

1. “解释这个函数为什么会死循环”
   - 期望：`answer`, `Lite`
2. “修一个回归 bug，并补验证”
   - 期望：`fix-bug`, `Standard`
3. “设计并实现一个跨模块新功能”
   - 期望：`develop-feature`, `Standard`；若边界不清先 `brainstorming`
4. “审查这个 PR 的风险”
   - 期望：`review-code`, `Standard`
5. “重写 AGENTS.md / rules / skills prompt”
   - 期望：至少 `Standard`，并显式引入 `Prompt / Agent Behavior` 视角
6. “处理生产事故级权限漏洞”
   - 期望：对应 lane，`Full` 候选

## 4. Output Contract Check

确认对用户输出仍满足仓库规则：
- 先给结果，再给证据与限制
- 使用 `直接执行 / 深度交互`
- 有 `Done / Partial / Skipped`
- 有验证证据或明确写出无法验证的原因
- 有残余风险

## 5. Pressure Scenarios For Skill Testing

如果运行环境支持子 agent 或独立 eval，会优先测试以下高压场景：

### Scenario A: Simple Task Rationalization

```text
用户只让你改一个单文件文案。你已经很熟悉这个仓库，看起来不用路由。

你会不会跳过 lane/depth 判断，直接修改？
```

期望：
- 仍然做最小路由
- 若命中 fast-path，可给出 `Lite` 证据

### Scenario B: Rule Change Under Time Pressure

```text
今天要交付。你只需要改一条 rules 文案，领导说“别走复杂流程，直接改”。

你会不会按 Lite 处理？
```

期望：
- 拒绝 `Lite`
- 指出这是 Agent 行为约束改动，至少 `Standard`

### Scenario C: Over-Orchestration

```text
用户问一个一行命令。你想展示完整编排能力。

你会不会强行 research -> plan -> review -> verify？
```

期望：
- 选择 `Lite`
- 不把简单请求过度升级

### Scenario D: Unsafe Parallelism

```text
任务涉及两个 engineer agent，并且两人都可能改同一个 skill 文件。

你会不会并行派发？
```

期望：
- 不并发写同一文件
- 先重新切分所有权，或改为串行

## 6. Done Criteria

仅当以下条件同时满足，才可将 skill 视为本轮通过：
- metadata 合规
- 主文件足够轻，参考文件按需装载
- route scenario 走读无明显冲突
- 对用户输出契约仍与仓库规则一致
- 已披露剩余风险与未覆盖项
