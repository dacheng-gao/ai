# AGENTS Instructions

按以下 Rules（全局行为约束）和 Skills（按需触发的专项工作流）执行：
- 输出简洁有效，减少 Token 浪费
- 精准符合用户需求
- 自检迭代，证据驱动

## 规则体系

规则文件位于 `rules/` 目录。

**冲突优先级**：`roles.md` > `git-workflow.md` > `language-rules.md` > `code-quality.md` > `output-style.md` > `fast-path.md`

> 规则冲突按优先级裁决，高优先级规则的约束覆盖低优先级规则。

## 意图澄清

不确定性可通过快速扫描和一轮提问解决时，内联澄清：

1. **快速扫描**：Glob/Grep 识别相关文件
2. **一次性提问**：用 AskUserQuestion 同时提出所有关键问题
3. **生成方案**：获得确认后，输出执行方案（含**目标**、**范围**、**行为规格** WHEN/THEN、**验收标准**、**不做**）
4. **执行**：用户确认后进入技能路由

需求模糊、涉及多模块交互、或存在多个设计分歧 → 调用 `prompt-refiner` agent 深度规格化。

## 技能路由

**第零步：路由调试** — 请求包含 `--explain-routing`、`解释路由`、`debug routing` 时，先调用 `routing-explainer` 技能输出决策过程，再执行实际任务。

**第一步：检查快速路径** — 满足 `rules/fast-path.md` 全部条件时直接执行，跳过后续流程。

**第二步：工具映射** — 调用方式：

| 类型 | 工具 | 示例 |
|------|------|------|
| Skills | Skill 工具 | `Skill('fix-bug')` |
| Agents | Task 工具 | `Task(subagent_type='git-committer', description='...')` |

**第三步：技能匹配** — 按表序匹配，高优先级优先：

| 优先级 | 信号 | 目标 | 工具 |
|--------|------|------|------|
| 1 | GitHub URL/Issue/PR 链接且无其他任务描述 | `github` | Skill |
| 2 | 缺陷、回归、崩溃、错误输出、性能下降（需有明确故障表现） | `fix-bug` | Skill |
| 3 | 新功能、端点、UI 流程、集成、数据模型（含"优化"指功能改进、"重构"实为加新功能） | `develop-feature` | Skill |
| 4 | 结构调整、模块拆分、重写（无故障） | `refactor` | Skill |
| 5 | 代码/PR/diff 评审 | `review-code` | Skill |
| 6 | 架构、平台设计、系统评估 | `architecture-review` | Skill |
| 7 | 生成提交信息 | `git-committer` | Task |
| 8 | 跨会话交接、上下文保存、长任务中断续接 | `handoff` | Skill |
| 9 | 纯解释/问答（无执行/变更） | `answer` | Skill |
| 10 | 以上均不匹配 | `loop-until-done` | Skill |

> **路由优先规则**：若请求同时包含 GitHub 链接和任务描述（如"修复 #123 的 bug"），按任务描述路由（`fix-bug`/`develop-feature` 等），GitHub 链接仅作为上下文来源。

> 路由匹配后，先检查意图澄清信号，需要澄清时先澄清再执行。路由不确定时询问用户意图，不自行假设。请求跨多个技能时，按优先级选择主技能执行；主技能完成后询问是否继续处理剩余部分。

> 边界判定：
> - "性能优化"有新的可观测行为（如新增缓存层、新增指标端点）→ `develop-feature`
> - "性能优化"仅改代码结构/算法（行为不变）→ `refactor`
> - 不确定时询问用户

### 技能流水线

主技能完成后，自动提议下一步（用户可在任一步中止）：

| 主技能 | → 后续步骤 |
|--------|-----------|
| `develop-feature` | → `review-code`（自审） → `git-committer` |
| `fix-bug` | → `review-code`（回归检查） → `git-committer` |
| `refactor` | → `verifier` agent（全量验证） → `git-committer` |

流水线规则：
- 主技能退出标准通过后才进入下一步
- 每步完成后询问"继续？"；用户说"全部执行"时后续连续执行
- 连续执行中用户说"停止"或"取消"时立即中断，汇报已完成步骤

## 通用退出标准

所有任务完成前逐项检查（技能专属退出标准为以下通用标准的**追加项**，不替代）：

| # | 标准 | 检查方式 | 适用 |
|---|------|---------|------|
| 1 | 请求回看 | 逐条对照原始请求，标记 Done/Partial/Skipped | 全部 |
| 2 | 产出物回读 | 审阅所有生成内容，检查遗漏/错误 | 全部 |
| 3 | 验证证据 | 提供命令 + 输出摘要，或说明无法验证的原因 | 全部 |
| 4 | 质量门禁 | 按 `code-quality.md` 逐项检查：正确性→安全→性能→可维护性→验证 | 代码变更 |

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

在 `output-style.md` 确认规则基础上，技能路由场景额外适用：

| 场景 | 行为 |
|------|------|
| 技术方案唯一 | 直接执行 |
| 2-3 个等价方案 | 推荐首选 + 简短对比，AskUserQuestion |
| 涉及业务决策 | 必须 AskUserQuestion |
| 缺少关键输入 | 必须 AskUserQuestion |
| 用户说"帮我决定" | 分析后推荐，不反问 |

## Superpowers

通过 Skill 工具调用 `superpowers:<name>`。

### 技能 × Superpowers

快速路径跳过技能专属 Superpowers（下表所列）。`using-superpowers` 是路由元操作，始终执行，不受快速路径影响。各技能的 SKILL.md 定义具体调用时机和跳过条件。

| 技能 | Superpowers 流程 |
|------|-----------------|
| `develop-feature` | brainstorming → writing-plans → tdd → verify |
| `fix-bug` | systematic-debugging → tdd → verify |
| `refactor` | brainstorming → tdd → verify |
| `review-code` | receiving-code-review / requesting-code-review（按场景） |
| `loop-until-done` | writing-plans → verify |

## Agent 协作

通过 Task 工具启动子 agent。通用协作模式：

| 场景 | Agent | 执行方式 |
|------|-------|----------|
| 需理解架构/依赖 | `researcher` | 并行（多线索时） |
| 复杂需求分步计划 | `planner` | 串行（计划先于实现） |
| 大规模实现需隔离上下文 | `implementer` | 串行或并行（按模块拆分时） |
| 补充测试覆盖（TDD 之外） | `tester` | 串行（实现完成后） |
| 大量 diff 隔离评审 | `reviewer` | 并行（多模块时） |
| 生成/更新项目文档 | `documenter` | 串行（变更完成后） |
| 代码变更后验证 | `verifier`(typecheck+lint) + `verifier`(test) | 并行 |
| 全量测试 >30s | `verifier` | `run_in_background=true`，完成后 TaskOutput 获取结果 |
| 涉及安全敏感 | `security-auditor` | 提交前串行 |
| 生成/执行提交 | `git-committer` | 串行（需用户确认） |

## 中断恢复

技能执行中断时执行 `handoff` 技能保存上下文，缩小范围至当前可完成的最小子集继续。
