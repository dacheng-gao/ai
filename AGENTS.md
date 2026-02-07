# AGENTS Instructions

AI Agent 工作规范框架。通过 Rules（全局行为约束，每次会话加载）和 Skills（按需触发的专项工作流）约束 Agent 行为，实现：
- 输出简洁有效，减少 Token 浪费
- 精准符合用户需求
- 自检迭代，证据驱动

## 规则加载（CRITICAL）

**在处理任何任务之前，必须先加载以下规则文件：**

1. `rules/roles.md` - 定义 AI 工具的角色和行为模式
2. `rules/git-workflow.md` - Git 工作流程规范
3. `rules/language-rules.md` - 语言使用规范（中文编写，技术内容用英文）
4. `rules/output-style.md` - 输出格式和风格要求

**加载方式：**
- 在会话开始时一次性加载所有规则文件
- 使用 Read 工具读取
- 确保规则内容在整个会话中生效

**规则验证：**
执行任务前检查规则是否已正确加载。如果缺失任何规则文件，立即停止并提醒用户配置问题。

**冲突处理：**
- 规则优先级：roles.md > git-workflow.md > language-rules.md > output-style.md
- 高优先级规则覆盖低优先级规则的矛盾部分
- 不同范围规则同时生效（如角色 vs 语言）

## 技能路由

收到用户请求后，按以下优先级匹配技能：

| 任务特征 | 触发技能 |
|---------|----------|
| 新功能、端点、UI 流程、集成、数据模型 | `develop-feature` |
| 缺陷、回归、崩溃、错误输出、性能下降 | `fix-bug` |
| 结构调整、性能优化、模块拆分、重写 | `refactor` |
| 代码/PR/diff 评审 | `review-code` |
| 架构、平台设计、系统评估 | `architecture-review` |
| 生成提交信息 | `commit-message` |
| **以上均不匹配** | `loop-until-done`（默认） |

> 按表格从上到下匹配首个符合的技能。边界模糊时优先匹配更具体的技能。
