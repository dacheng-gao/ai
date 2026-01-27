# AGENTS Instructions

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
