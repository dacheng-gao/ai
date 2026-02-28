# AGENTS Instructions

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

- 快速路径任务：跳过任务追踪
- 复杂任务（≥3 步或跨多文件）：使用 TaskCreate/TaskUpdate/TaskList

| 时机 | 操作 |
|------|------|
| 任务分解后 | TaskCreate 为每个步骤创建 task（含 activeForm） |
| 开始某步骤 | TaskUpdate → `in_progress` |
| 完成某步骤 | TaskUpdate → `completed`，并用 TaskList 选择下一个 |
| 步骤存在依赖 | 用 `addBlockedBy` 声明阻塞关系 |
| 中断恢复 | 从 TaskList 读取进度并继续未完成项 |

简单任务（≤3 步、≤2 文件）直接执行，不建 task。

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
- 固定顺序：`using-superpowers` → 选择最小 Skill 集合 → Skill 内专属 Superpowers → 验证与交付
- 单次命中多个 Skill：先窄后宽（先专用 Skill，再兜底 `loop-until-done`）
- 规则冲突优先级：安全 > 正确性 > 用户明确要求 > `CLAUDE.md` 强制项 > 其余规则/技能说明

### Superpowers 场景映射（默认）

| 场景 | Superpower | 说明 |
|------|------------|------|
| 需求模糊/多方案 | `superpowers:brainstorming` | 收敛边界与方案 |
| 新功能/缺陷/重构实现 | `superpowers:test-driven-development` | 先验证行为再落地实现 |
| 交付前自检 | `superpowers:verification-before-completion` | 确保验证证据完整 |
| 收到评审反馈 | `superpowers:receiving-code-review` | 消化反馈并转成修复动作 |
| 需要二次评审 | `superpowers:requesting-code-review` | 产出可执行审查输入 |

## Agent 协作

### 职责边界

| 层级 | 职责 | 示例 |
|------|------|------|
| Skill | 路由层：匹配任务类型并调用对应 Superpowers/Agents | `review-code` 调用 `reviewer` |
| Agent | 执行层：按单一职责完成具体任务 | `reviewer` 执行代码评审 |

Skill 不内联复杂逻辑，应委派 Agent 执行。

### 委派优先原则

主 agent 负责编排，默认通过 Task 工具委派子 agent，保持主上下文精简。

主 agent 保留（不委派）：
- 编排决策
- 用户交互（AskUserQuestion、确认提示）
- 快速路径执行（满足 `rules/fast-path.md` 全部条件时）
- 最终结果汇总与呈现
- 任务协调（TaskCreate/TaskUpdate/TaskList）

其余工作委派：

| 工作类型 | Agent | 执行方式 |
|---------|-------|----------|
| 代码探索/架构理解 | `researcher` | 并行（多线索） |
| 需求分步计划 | `planner` | 串行（计划先于实现） |
| 代码实现/修改 | `implementer` | 串行或并行（按模块拆分） |
| 测试编写 | `tester` | 串行（实现后） |
| 代码评审 | `reviewer` | 并行（多模块） |
| 验证（typecheck/lint/test） | `verifier` | 并行；>30s 用 `run_in_background=true` |
| 结果汇报 | `reporter` | 串行（收敛后汇总） |
| 安全审计 | `security-auditor` | 提交前串行 |
| 提示词审查 | `prompt-engineer` | 串行 |
| 生成/执行提交 | `git-committer` | 串行（需用户确认） |

## 文件引用规范

引用项目内文件时使用相对路径：
- Rules: `rules/code-quality.md`、`rules/fast-path.md`
- Skills: `skills/develop-feature/SKILL.md`
- Agents: `agents/reviewer.md`

避免仅写文件名（如 `code-quality.md`），确保可追溯。

## 中断恢复

技能执行中断时调用 `handoff`（详见其 SKILL.md）。
