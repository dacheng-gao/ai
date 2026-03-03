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

1. 快速扫描：Glob/Grep 识别相关文件
2. 一次性提问：用 AskUserQuestion 提出全部关键问题并等待回答
3. 生成方案：基于回答输出目标、范围、WHEN/THEN 行为规格、验收标准、不做项
4. 执行：用户确认后开始

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
- 非 superagents 路径也必须满足最小追踪：步骤状态可见、阻塞关系可见、完成证据可追溯

## 用户交互决策

以下为 `rules/output-style.md` 确认规则的补充（前者管“是否确认”，此处管“是否询问方向”）：

| 场景 | 行为 |
|------|------|
| 技术方案唯一 | 直接执行 |
| 2-3 个等价方案 | 推荐首选 + 简短对比，AskUserQuestion |
| 涉及业务决策 | 必须 AskUserQuestion |
| 缺少关键输入 | 必须 AskUserQuestion |
| 用户说“帮我决定” | 分析后给推荐，不反问 |

## Superpowers 使用准则

- 每次响应前必须先调用 `superpowers:using-superpowers`（见 `CLAUDE.md`）
- 固定顺序：`using-superpowers` → 选择最小 Skill 集合 → 执行对应 Skill → 验证与交付
- 工程任务默认进入 `superagents`；轻量单一任务可直达专用 Skill（`answer/git/github/handoff` 等）
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
