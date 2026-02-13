# AGENTS Instructions

按以下 Rules（全局行为约束）和 Skills（按需触发的专项工作流）执行：
- 输出简洁有效，减少 Token 浪费
- 精准符合用户需求
- 自检迭代，证据驱动

## 规则体系

规则文件位于 `rules/` 目录。

**冲突优先级**：`roles.md` > `git-workflow.md` > `language-rules.md` > `code-quality.md` > `output-style.md`

> 规则冲突按优先级裁决，高优先级规则的约束覆盖低优先级规则。

## Phase 0: Prompt Review

用户请求到达后，`UserPromptSubmit` hook 自动检测清晰度并注入信号。

### 信号与行为

| Hook 信号 | 含义 | 行为 |
|-----------|------|------|
| 无输出 | 请求清晰 | 直接进入技能路由 |
| `<workspace-context>` | 中等清晰 | 参考上下文辅助推断，直接执行 |
| `<refine-prompt>` | 请求模糊 | 执行意图审查，生成执行方案 |

### 收到 `<refine-prompt>` 时

1. **快速扫描**：Glob/Grep（≤3 次）识别相关文件
2. **意图推断**：结合代码库上下文理解用户目标
3. **必要时澄清**：意图有多种合理解读时，用 AskUserQuestion 让用户选择（不反复追问）
4. **生成执行方案**：

```
## [type]: [标题]

### 目标
[1-2 句，最终状态]

### 范围
- [文件/模块列表]
- [改动类型：新增/修改/删除]

### 行为规格
- WHEN [条件] THEN [预期行为]

### 验收标准
- [ ] [可量化/可验证条件]

### 不做
- [明确排除项]
```

其中 `type` 对应技能路由：`feat` → develop-feature、`fix` → fix-bug、`refactor` → refactor、`review` → review-code、`chore` → loop-until-done

5. **呈现用户**：输出方案，等待确认或修改
6. **确认后执行**：将确认后的方案作为输入，进入技能路由

### 跳过条件

收到 `<refine-prompt>` 后，如分析判断请求已足够明确（如用户用口语但意图单一、目标明确），可跳过方案生成直接执行。

### 深度分析（可选）

满足以下任一条件时委托 `prompt-refiner` agent（隔离探索上下文，≤10 次工具调用）：
- 需跨 ≥3 个目录搜索相关文件
- 需理解复杂依赖关系（数据流、调用链）
- 主对话已接近上下文上限

## 技能路由

收到用户请求后，按表序从高到低匹配首个技能：

| 信号 | 技能 |
|------|------|
| GitHub URL、`#123`、`PR 456`、`issue N` | `github` |
| 缺陷、回归、崩溃、错误输出、性能下降（需有明确故障表现） | `fix-bug` |
| 新功能、端点、UI 流程、集成、数据模型（含"优化"指功能改进、"重构"实为加新功能） | `develop-feature` |
| 结构调整、模块拆分、重写（无故障） | `refactor` |
| 代码/PR/diff 评审 | `review-code` |
| 架构、平台设计、系统评估 | `architecture-review` |
| 生成提交信息 | `commit-message` |
| 跨会话交接、上下文保存、长任务中断续接 | `handoff` |
| 纯解释/问答（无执行/变更） | `answer` |
| 以上均不匹配 | `loop-until-done` |

> 路由不确定时询问用户意图，不自行假设。请求跨多个技能时，按优先级选择主技能执行；主技能完成后询问是否继续处理剩余部分。

> 边界判定：
> - "性能优化"有新的可观测行为（如新增缓存层、新增指标端点）→ `develop-feature`
> - "性能优化"仅改代码结构/算法（行为不变）→ `refactor`
> - 不确定时询问用户

### 技能流水线

主技能完成后，自动提议下一步（用户可在任一步中止）：

| 主技能 | → 后续步骤 |
|--------|-----------|
| `develop-feature` | → `review-code`（自审） → `commit-message` |
| `fix-bug` | → `review-code`（回归检查） → `commit-message` |
| `refactor` | → verifier（全量验证） → `commit-message` |

流水线规则：
- 主技能退出标准通过后才进入下一步
- 每步完成后简短告知用户结果，询问"继续下一步？"
- 用户说"全部执行"时，后续步骤连续执行不再逐步确认

## 通用退出标准

所有任务（含非代码变更）完成前必须逐项通过：

1. **请求回看**：重新阅读用户原始请求，逐条列出每个要求的完成状态（`Done` / `Partial` / `Skipped + 理由`）。存在 `Partial` 或未覆盖项即未完成
2. **产出物回读**：重新阅读自己生成的全部产出物（代码、文档、配置），以评审者视角检查是否有遗漏、错误或与请求不符之处
3. **验证证据**：提供验证证据（执行的命令 + 输出结果摘要），或说明无法验证的原因与残余风险

代码变更任务额外要求：
4. **测试**：测试通过（或已记录测试计划与理由）
5. **无回归**：不引入新的故障或行为变化
6. **diff 自审**：回读自己的改动 diff，检查是否包含调试代码、遗留注释、超出请求范围的变更
7. **质量门禁**：五维（正确性/安全/性能/可维护性/验证）逐项判定 Pass/Concern，存在 Concern 则未通过

**迭代验证**：退出标准检查未全部通过 → 修复后重新检查，硬上限 3 轮。达到上限仍有未通过项 → 向用户说明残余问题与权衡理由，不隐藏。

## 任务追踪

复杂任务（≥3 步骤或跨多文件）使用 TaskCreate 建立结构化清单：

| 时机 | 操作 |
|------|------|
| 任务分解后 | TaskCreate 为每个步骤创建 task（含 activeForm） |
| 开始某步骤 | TaskUpdate → `in_progress` |
| 完成某步骤 | TaskUpdate → `completed`，检查 TaskList 找下一个 |
| 步骤间有依赖 | 用 `addBlockedBy` 声明阻塞关系 |
| 中断恢复时 | 从 TaskList 获取当前进度，继续未完成项 |

> 简单任务（≤2 步、单文件）直接执行，不建 task。

## Memory 管理

auto-memory 目录按主题分文件管理，`MEMORY.md` 为索引（≤200 行，自动加载）。

| 文件 | 内容 | 写入时机 |
|------|------|---------|
| `MEMORY.md` | 项目概要、关键路径、用户偏好索引 | 确认稳定模式后 |
| `patterns.md` | 代码模式、架构约定、技术栈细节 | 发现可复用模式时 |
| `decisions.md` | 关键技术决策与理由 | 做出重要决策后 |
| `debugging.md` | 调试经验、踩坑记录、解决方案 | 解决非显然问题后 |

写入规则：
- 仅记录跨会话有价值的信息，不记录当前会话临时状态
- 用户明确要求记住的内容立即写入
- 已验证的结论才写入，推测性内容不写入
- 定期清理过时条目

## 中断恢复

技能执行中断（上下文溢出、工具故障、用户中止）时：
1. 输出已完成步骤与当前进度摘要
2. 列出未完成项与已知阻塞点
3. 长任务或多步骤任务 → 执行 `handoff` 技能保存结构化上下文
4. 缩小范围至可在当前上下文完成的最小子集，恢复执行

## Plan Mode 工作流

复杂任务使用 Claude Code 的 Plan Mode（EnterPlanMode 工具）进行结构化计划。

| 场景 | 行为 |
|------|------|
| Claude Code + 复杂任务（schema/API/鉴权/≥3 模块/迁移） | 调用 EnterPlanMode 进入 Plan Mode |
| Claude Code + 简单任务（≤4 步、单模块） | 内联 3-5 行计划 |
| 非 Claude Code 环境（Codex 等） | `superpowers:writing-plans` 或 `planner` agent |

### Plan 文件模板

```markdown
# [功能/任务名称]

## 目标
[1-2 句话描述最终状态]

## 前提条件
- [已确认的依赖/环境/权限]

## 实施步骤
1. [步骤] — [涉及文件/模块]
2. ...

## 风险
- [风险项] → [缓解措施]

## 验收标准
- [ ] [可验证的条件]
```

### Fallback 规则

EnterPlanMode 不可用时（非 Claude Code 环境、工具受限）：
1. 优先调用 `planner` agent 生成计划
2. `planner` 不可用 → 使用 `superpowers:writing-plans`
3. 均不可用 → 在回复中内联输出计划

## 用户交互决策

使用 AskUserQuestion 工具的时机：

| 场景 | 行为 |
|------|------|
| 技术方案唯一 | 直接执行 |
| 2-3 个等价方案 | 推荐首选 + 简短对比，AskUserQuestion |
| 涉及业务决策 | 必须 AskUserQuestion |
| 缺少关键输入 | 必须 AskUserQuestion |
| 用户说"帮我决定" | 分析后推荐，不反问 |

> 与 `output-style.md` 确认规则互补：本表覆盖"需要用户输入"的场景，确认规则覆盖"破坏性/不可逆操作"的场景。

## Superpowers

通过 `superpowers:<name>` 调用高阶提示词模板。Claude Code 自动加载；其他环境按下表 fallback 降级。未列出的 superpower 不可用时按常识降级。

| Superpower | Fallback |
|-----------|----------|
| `brainstorming` | 3-5 行内联计划，列出核心步骤和验收标准 |
| `writing-plans` | 在回复中输出计划（可选落盘） |
| `test-driven-development` | 先写失败测试 → 实现 → 验证通过 |
| `systematic-debugging` | 复现 → 收集证据 → 定位根因 → 修复 |
| `verification-before-completion` | 按通用退出标准验证 |
| `receiving-code-review` | 逐条回应反馈，验证技术正确性后再实施 |

### 技能 × Superpowers 激活矩阵

每个技能的 SKILL.md 定义了具体调用时机。下表为全局强制规则：

| 技能 | 必须激活的 Superpowers |
|------|----------------------|
| `develop-feature` | brainstorming → writing-plans（复杂时） → test-driven-development → verification-before-completion |
| `fix-bug` | systematic-debugging → test-driven-development → verification-before-completion |
| `refactor` | brainstorming（复杂时） → test-driven-development → verification-before-completion |
| `review-code` | verification-before-completion |
| `loop-until-done` | writing-plans（≥3 步时） → verification-before-completion |

> 各 SKILL.md 中定义的跳过条件仍然有效。矩阵确保不遗漏关键环节。

## 自定义 Agents

通过 `agents/` 目录定义的专用子 agent。在 Task 工具中通过 `subagent_type` 指定。

| Agent | 模型 | 用途 | 时机 |
|-------|------|------|------|
| `researcher` | sonnet | 深度代码库探索，返回结构化结论 | 需要多轮搜索理解架构/数据流时 |
| `verifier` | haiku | 执行 typecheck → lint → test 验证流程 | 代码变更完成后、退出标准验证时 |
| `planner` | sonnet | 任务分解与实现计划生成 | 复杂需求的计划阶段 |
| `reviewer` | sonnet | 独立代码评审（隔离大量 diff） | 技能流水线中的自审步骤 |
| `security-auditor` | sonnet | 安全专项审计 | 涉及鉴权/外部输入/敏感数据时 |
| `prompt-refiner` | sonnet | 提示词深度优化 | 模糊请求需结构化转化时 |

> 子 agent 的输出隔离在独立上下文中，不消耗主对话窗口。优先委托耗费上下文的操作（大量搜索、冗长命令输出）给子 agent。

### 并行执行

独立子任务应在同一消息中并行发起多个 Task 调用：

| 场景 | 并行组合 |
|------|---------|
| Feature 启动（需理解多个模块） | researcher(架构) + researcher(依赖/接口) |
| 代码变更完成 | verifier(typecheck+lint) + verifier(test) |
| Bug 定位（多条线索） | researcher(日志/错误) + researcher(代码路径) |
| 大规模评审 | reviewer(变更理解) + reviewer(影响分析) |

规则：
- 仅并行无依赖的任务；有依赖的按顺序执行
- 每个并行 Task 用不同 prompt 明确职责边界
- 耗时操作（全量测试 >30s、大规模搜索）用 `run_in_background=true`，不阻塞用户交互
