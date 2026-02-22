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

不确定性可通过快速扫描和一轮提问解决时，内联澄清：

1. **快速扫描**：Glob/Grep 识别相关文件
2. **一次性提问**：用 AskUserQuestion 同时提出所有关键问题 → 等待用户回答
3. **生成方案**：基于用户回答，输出执行方案（含**目标**、**范围**、**行为规格** WHEN/THEN、**验收标准**、**不做**）
4. **执行**：用户确认方案后开始执行

需求模糊、涉及多模块交互、或存在多个设计分歧 → 调用 `superpowers:brainstorming` skill 进行意图澄清和收敛业务边界。

## 通用退出标准

所有任务完成前逐项检查（技能专属退出标准为以下通用标准的**追加项**，不替代）：

| # | 标准 | 检查方式 |
|---|------|---------|
| 1 | 请求回看 | 逐条对照原始请求，标记 Done/Partial/Skipped |
| 2 | 产出物回读 | 审阅所有生成内容，检查遗漏/错误 |
| 3 | 验证证据 | 提供命令 + 输出摘要，或说明无法验证的原因 |
| 4 | 质量门禁 | 按 `code-quality.md` 逐项检查：正确性→安全→性能→可维护性（验证按适用性执行） |

未通过自动修复，最多 3 轮。3 轮后仍有问题 → 明确列出残余风险，禁止隐藏。

## 任务追踪

快速路径任务跳过任务追踪。复杂任务（≥3 步骤或跨多文件）使用 TaskCreate 建立结构化清单：

| 时机 | 操作 |
|------|------|
| 任务分解后 | TaskCreate 为每个步骤创建 task（含 activeForm） |
| 开始某步骤 | TaskUpdate → `in_progress` |
| 完成某步骤 | TaskUpdate → `completed`，检查 TaskList 找下一个 |
| 步骤间有依赖 | 用 `addBlockedBy` 声明阻塞关系 |
| 中断恢复时 | 从 TaskList 获取当前进度，继续未完成项 |

> 简单任务（≤3 步、≤2 文件）直接执行，不建 task。

## 用户交互决策

以下为 `output-style.md` 确认规则的**补充**（确认规则管"是否确认"，本表管"是否询问方向"）：

| 场景 | 行为 |
|------|------|
| 技术方案唯一 | 直接执行 |
| 2-3 个等价方案 | 推荐首选 + 简短对比，AskUserQuestion |
| 涉及业务决策 | 必须 AskUserQuestion |
| 缺少关键输入 | 必须 AskUserQuestion |
| 用户说"帮我决定" | 分析后推荐，不反问 |

## Agent 协作

### 委派优先原则

主 agent 为编排层，默认通过 Task 工具委派子 agent 执行，保持主上下文精简。

**主 agent 保留**（不委派）：
- 编排决策
- 用户交互（AskUserQuestion、确认提示）
- 快速路径执行（满足 `fast-path.md` 全部条件时）
- 最终结果汇总与呈现
- 任务协调（TaskCreate/TaskUpdate/TaskList）

**其余工作一律委派**：

| 工作类型 | Agent | 执行方式 |
|---------|-------|----------|
| 代码探索/架构理解 | `researcher` | 并行（多线索时） |
| 需求分步计划 | `planner` | 串行（计划先于实现） |
| 代码实现/修改 | `implementer` | 串行或并行（按模块拆分） |
| 测试编写 | `tester` | 串行（实现完成后） |
| 代码评审 | `reviewer` | 并行（多模块时） |
| 验证（typecheck/lint/test） | `verifier` | 并行；>30s 时 `run_in_background=true` |
| 安全审计 | `security-auditor` | 提交前串行 |
| 提示词审查 | `prompt-engineer` | 串行 |
| 生成/执行提交 | `git-committer` | 串行（需用户确认） |

## 中断恢复

技能执行中断时调用 `handoff` 技能（完整流程见其 SKILL.md）。
