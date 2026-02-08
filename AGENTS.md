# AGENTS Instructions

AI Agent 工作规范框架。通过 Rules（全局行为约束）和 Skills（按需触发的专项工作流）约束 Agent 行为，实现：
- 输出简洁有效，减少 Token 浪费
- 精准符合用户需求
- 自检迭代，证据驱动

## 规则体系

规则文件位于 `rules/` 目录。非 Claude Code 工具须先调用 `session-init` 技能加载规则。

**冲突优先级**：`roles.md` > `git-workflow.md` > `language-rules.md` > `code-quality.md` > `output-style.md`

## 技能路由

收到用户请求后，按以下优先级匹配首个技能：

| 任务特征 | 触发技能 |
|---------|----------|
| GitHub URL/引用（#123, PR 456） | `github` |
| 新功能、端点、UI 流程、集成、数据模型 | `develop-feature` |
| 缺陷、回归、崩溃、错误输出、性能下降 | `fix-bug` |
| 结构调整、性能优化、模块拆分、重写 | `refactor` |
| 代码/PR/diff 评审 | `review-code` |
| 架构、平台设计、系统评估 | `architecture-review` |
| 生成提交信息 | `commit-message` |
| 解释代码、回答问题、知识问答 | `answer` |
| 以上均不匹配 | `loop-until-done`（默认） |

### 路由边界判定

| 信号 | 路由 |
|------|------|
| GitHub URL、#123、PR 456、issue N | `github` |
| 有明确故障/错误表现 | `fix-bug` |
| 无故障但结构需调整 | `refactor` |
| 新增用户可感知能力 | `develop-feature` |
| 用户说"优化"但指功能改进 | `develop-feature`（非 `refactor`） |
| 用户说"重构"但实际是加新功能 | `develop-feature`（非 `refactor`） |
| 仍不明确 | `loop-until-done` |

> 路由不确定时询问用户意图，不自行假设。

## 代码变更通用退出标准

- 测试通过（或已记录测试计划与理由）
- 无回归
- 验证证据已提供
