# AGENTS.md

本文件提供可复用的 AI 辅助开发规则和技能。克隆到 `~/.ai` 目录，并配置 AI 工具引用此文件。

## 项目结构

```
~/.ai/
├── AGENTS.md          # 本文件 - AI 工具的主入口
├── rules/             # 全局规则（由 AI 工具自动加载）
├── skills/            # 可调用技能（每个技能包含 SKILL.md）
├── README.md          # 用户安装指南
└── LICENSE
```

**核心概念：**
- **规则 (Rules)**: 自动在会话开始时加载的全局指令
- **技能 (Skills)**: 按需调用的专业工作流程和模式

## 规则加载

**CRITICAL**: 在处理任何任务之前，必须先加载以下规则文件：

1. 加载 `rules/roles.md` - 定义 AI 工具的角色和行为模式
2. 加载 `rules/git-workflow.md` - Git 工作流程规范
3. 加载 `rules/language-rules.md` - 语言使用规范（中文编写，技术内容用英文）
4. 加载 `rules/output-style.md` - 输出格式和风格要求

**加载方式**:
- 使用 Read 工具读取上述文件
- 在会话开始时一次性加载所有规则
- 确保规则内容在整个会话中生效

**冲突处理**:
- 规则优先级：roles.md > git-workflow.md > language-rules.md > output-style.md
- 高优先级规则覆盖低优先级规则的矛盾部分
- 规则范围不同时（如角色 vs 语言）同时生效，不冲突

**规则验证**:
在执行任务前，检查规则是否已正确加载。如果缺失任何规则文件，立即停止并提醒用户配置问题。

## 技能加载

本系统提供可调用的专业技能，涵盖开发工作流程的各个方面：

### 可用技能列表

- `session-init` - 会话初始化（必须在任何响应前调用）
- `develop-feature` - 新功能开发规划和实现
- `fix-bug` - 缺陷修复和回归处理
- `refactor` - 代码重构和结构调整
- `review-code` - 代码审查和安全检查
- `architecture-review` - 架构评估和设计审查
- `verification-before-completion` - 任务完成前的最终验证
- `commit-message` - 生成符合规范的提交信息
- `loop-until-done` - 迭代执行直到完成

### 技能调用规则

**CRITICAL**: 当任务明显匹配任何技能描述时（50% 以上），必须调用对应的技能。

**调用流程**:
1. 检测任务类型是否匹配技能描述
2. 使用 Skill 工具加载对应技能
3. 遵循技能中的步骤和流程
4. 完成后标记技能完成状态

**技能优先级**:
当多个技能适用时，按此顺序选择：
1. 流程类技能（session-init）- 确定工作方式
2. 实现类技能（develop-feature, fix-bug, refactor）- 指导执行
3. 评审类技能（review-code, architecture-review）- 质量保证

### 技能文件位置

每个技能位于 `skills/<skill-name>/SKILL.md`，包含：
- 技能描述和使用场景
- 详细步骤和检查清单
- 示例和最佳实践
- 避坑指南和红旗条件

## 工作流程

### 会话初始化

1. **加载全局规则**: 使用 Read 工具加载 `rules/` 目录下的所有规则文件
2. **调用 session-init 技能**: 这是强制性的第一步，在任何用户请求之前必须调用
3. **验证环境**: 确认 `rules/` 和 `skills/` 目录可访问

### 任务处理流程

对于任何用户请求（包括简单问题）：

1. **技能检查**: 
   - 评估任务是否匹配任何技能描述
   - 当匹配度达到 50% 以上时，必须调用对应技能
   - 使用 Skill 工具加载技能内容

2. **遵循技能指引**:
   - 按技能中的步骤执行
   - 如有检查清单，使用 TodoWrite 创建待办项
   - 严格遵守技能中的红旗条件

3. **使用全局规则**:
   - 在整个过程中应用已加载的规则
   - 遵循语言规范（中文编写，技术内容用英文）
   - 按 git-workflow 处理版本控制操作

### 复杂任务流程

对于涉及多个步骤或未知领域的任务：

1. **Planning Phase**: 使用 `develop-feature` 技能进行规划和设计
2. **Execution Phase**: 在计划确认后执行实现
3. **Verification Phase**: 使用 `verification-before-completion` 进行最终验证

### Git 工作流程

- 始终使用 `commit-message` 技能生成提交信息
- 未经用户明确批准，不要提交更改
- 遵循 `rules/git-workflow.md` 中的详细约束

### 输出格式

- 保持简洁直接
- 使用 GitHub 风格 Markdown
- 避免不必要的解释和总结
- 参考文件引用使用格式：`file_path:line_number`
