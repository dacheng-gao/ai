# AGENTS Instructions

按以下 Rules（全局行为约束）和 Skills（按需触发的专项工作流）执行：
- 输出简洁有效，减少 Token 浪费
- 精准符合用户需求
- 自检迭代，证据驱动

## 规则体系

规则文件位于 `rules/` 目录。

**冲突优先级**：`roles.md` > `git-workflow.md` > `language-rules.md` > `code-quality.md` > `output-style.md`

> 规则冲突按优先级裁决，高优先级规则的约束覆盖低优先级规则。

## 意图澄清

需要澄清时按以下流程执行：

1. **快速扫描**：Glob/Grep（≤3 次）识别相关文件
2. **一次性提问**：用 AskUserQuestion 同时提出所有关键问题
3. **生成方案**：获得确认后，输出执行方案（含**目标**、**范围**、**行为规格** WHEN/THEN、**验收标准**、**不做**）
4. **执行**：用户确认后进入技能路由

`type` 对应技能：`feat` → develop-feature、`fix` → fix-bug、`refactor` → refactor、`review` → review-code、`chore` → loop-until-done

## 技能路由

收到用户请求后，先检查快速路径条件（`rules/fast-path.md`），命中则直接执行。否则按表序匹配技能：

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

> 路由匹配后，先检查意图澄清信号，需要澄清时先澄清再执行。路由不确定时询问用户意图，不自行假设。请求跨多个技能时，按优先级选择主技能执行；主技能完成后询问是否继续处理剩余部分。

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

所有任务完成前逐项检查：

| # | 标准 | 检查方式 | 适用 |
|---|------|---------|------|
| 1 | 请求回看 | 逐条对照原始请求，标记 Done/Partial/Skipped | 全部 |
| 2 | 产出物回读 | 审阅所有生成内容，检查遗漏/错误 | 全部 |
| 3 | 验证证据 | 提供命令 + 输出摘要，或说明无法验证的原因 | 全部 |
| 4 | 质量门禁 | 代码变更额外执行 `code-quality.md` 五维门禁（含测试、无回归、diff 自审） | 代码变更 |

未通过自动修复，最多 3 轮。3 轮后仍有问题 → 明确列出残余风险，禁止隐藏。

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

## 用户交互决策

使用 AskUserQuestion 工具的时机：

| 场景 | 行为 |
|------|------|
| 技术方案唯一 | 直接执行 |
| 2-3 个等价方案 | 推荐首选 + 简短对比，AskUserQuestion |
| 涉及业务决策 | 必须 AskUserQuestion |
| 缺少关键输入 | 必须 AskUserQuestion |
| 用户说"帮我决定" | 分析后推荐，不反问 |

## Superpowers

通过 Skill 工具调用 `superpowers:<name>`。

### 技能 × Superpowers 默认激活矩阵

每个技能的 SKILL.md 定义了具体调用时机和跳过条件。快速路径跳过所有 Superpowers。

| 技能 | 默认激活的 Superpowers（满足跳过条件时跳过） |
|------|------------------------------------------|
| `develop-feature` | brainstorming → writing-plans（复杂时） → test-driven-development → verification-before-completion |
| `fix-bug` | systematic-debugging → test-driven-development → verification-before-completion |
| `refactor` | brainstorming（复杂时） → test-driven-development → verification-before-completion |
| `review-code` | verification-before-completion |
| `loop-until-done` | writing-plans（≥3 步时） → verification-before-completion |

## 中断恢复

技能执行中断时执行 `handoff` 技能保存上下文，缩小范围至当前可完成的最小子集继续。
