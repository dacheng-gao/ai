# AGENTS.md

## Karpathy-Inspired Guidelines

- Think Before Coding: Wrong assumptions, hidden confusion, missing tradeoffs
- Simplicity First: Overcomplication, bloated abstractions
- Surgical Changes: Orthogonal edits, touching code you shouldn't
- Goal-Driven Execution: Leverage through tests-first, verifiable success criteria

## User Rules

- Multiple Roles: 多角色视角分析和评审
- Output Style: 简洁、直接、可执行
- Language Rules: 内部开发过程中的语言以中文优先

## 意图澄清

适用条件：不确定性可通过快速扫描 + 一轮提问消除。

1. 开场对齐（执行前必做）：先向用户回显“我理解的目标/范围/不做/关键假设”
2. 请求规范化（Prompt Refinement）：将用户原始请求收敛为可执行摘要（目标/范围/不做/验收）
3. 快速扫描：Glob/Grep 识别相关文件
4. 关键提问：有疑问时提问并等待回答
5. 生成方案：基于回答输出目标、范围、WHEN/THEN 行为规格、验收标准、不做项
6. 执行：需求明确且实现路径唯一时直接开始；涉及业务决策/关键输入缺失/重大歧义时等待用户确认后开始

提问规则：
- `Lite` 且需求明确、实现路径唯一：不提问，直接执行
- `Standard/Full` 且需求明确、实现路径唯一：开场对齐后直接执行
- 涉及业务决策、缺少关键输入、或存在多方案权衡：一次性提出全部关键问题并等待确认
- 已进入 `superpowers:brainstorming` 时，按其规则改为“一次一问”
- `AskUserQuestion` 不可用时，改为普通文本提问并暂停执行等待用户回复

需求模糊、跨模块交互或存在多个设计分歧时，调用 `superpowers:brainstorming` 收敛边界。

## 通用退出标准

所有任务交付前逐项检查（技能专属退出标准仅追加，不替代）：

| # | 标准 | 检查方式 |
|---|------|---------|
| 1 | 请求回看 | 逐条对照原始请求，标记 Done/Partial/Skipped |
| 2 | 产出物回读 | 审阅所有生成内容，检查遗漏/错误 |
| 3 | 验证证据 | 提供命令 + 输出摘要，或说明无法验证原因 |
| 4 | 质量门禁 | 按 `rules/code-quality.md` 检查：正确性→安全→性能→可维护性（按适用性验证） |

未通过则自动修复，最多 3 轮；仍失败必须明确残余风险，禁止隐藏。

## 任务追踪

默认由 `skills/superagents/SKILL.md` 的编排与追踪规则执行。

- 快速路径任务：按 `rules/fast-path.md` 执行，可跳过任务追踪
- 复杂任务（≥3 步或跨多文件）：使用 TaskCreate/TaskUpdate/TaskList
- 所有档位路径（Lite/Standard/Full）都必须满足最小追踪：步骤状态可见、阻塞关系可见、完成证据可追溯

## 用户交互决策

以下为 `rules/output-style.md` 确认规则的补充（前者管“是否确认”，此处管“是否询问方向”）：

| 场景 | 行为 |
|------|------|
| 技术方案唯一 | 直接执行 |
| 2-3 个等价方案 | 推荐首选 + 简短对比，AskUserQuestion |
| 涉及业务决策 | 必须 AskUserQuestion |
| 缺少关键输入 | 必须 AskUserQuestion |
| 用户说“帮我决定” | 分析后给推荐，不反问 |

补充：`AskUserQuestion` 不可用时，使用普通文本一次性提问（最多 3 个关键问题）并等待用户确认。

## Superpowers 使用准则

- 每次响应前必须先调用 `superpowers:using-superpowers`（见 `CLAUDE.md`）
- 固定顺序：`using-superpowers` → 选择最小 Skill 集合 → 执行对应 Skill → 验证与交付
- 所有请求强制进入 `superagents`（自动触发，无需显式 `$superagents`）
- `superagents` 内部按复杂度走 `Lite/Standard/Full` 三档流程
- `answer/git/github/handoff/fix-bug/develop-feature/refactor/review-code/architecture-review` 仅作为 `superagents` 内部 lane
- 规则冲突优先级：安全 > 正确性 > 用户明确要求 > `CLAUDE.md` 强制项 > 其余规则/技能说明

具体场景映射与编排细节以 `skills/superagents/SKILL.md` 为准。

## Agent 协作

职责边界保持两层：

- Skill：负责路由与流程编排
- Agent：负责单一职责执行（research/plan/implement/review/verify/report）

委派原则（全局最小约束）：

- 主 agent 只保留：编排决策、用户交互、任务协调、最终汇总
- 可委派工作默认委派，避免主上下文膨胀
- 多 Agent 并发、角色分工、冲突处理以 `skills/superagents/SKILL.md` 为准

## 文件引用规范

引用项目内文件时使用相对路径：
- Rules: `rules/code-quality.md`、`rules/fast-path.md`
- Skills: `skills/develop-feature/SKILL.md`
- Agents: `agents/reviewer.md`

避免仅写文件名（如 `code-quality.md`），确保可追溯。

## 中断恢复

技能执行中断时调用 `handoff`（详见其 SKILL.md）。
