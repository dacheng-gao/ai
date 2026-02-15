# AI Agent Toolbox 🚀

让你的 AI 更聪明：可复用的规则和技能库，提升开发效率。

> **前置条件:** 首先设置 [Superpowers](https://github.com/obra/superpowers)。

---

## 项目概述

本项目是一个**跨 AI 编码工具**的行为规范框架，通过 **Rules**（全局行为约束）和 **Skills**（按需触发的专项工作流）统一约束 AI Agent 的工作方式。

### 解决的问题

原生 AI 编码助手常见的痛点：
- **输出冗余**：大量客套、复述、未请求的扩展内容，浪费 Token
- **偏离需求**：自行"改进"代码、添加未要求的功能，交付物与请求不符
- **缺乏验证**：声称"已完成"但未实际验证，遗留隐患
- **语言混乱**：中英文混用不一致，无明确的受众导向规则

### 工作原理

```
用户请求 → 技能路由（自动匹配最合适的工作流）→ 执行 → 自检迭代 → 交付
```

**Rules（6 个规则文件）** — 始终生效的全局约束：

| 规则 | 职责 |
|------|------|
| `roles.md` | 多视角分析（架构/实现/安全/产品/质量/提示词） |
| `git-workflow.md` | Conventional Commits、分步提交、操作确认 |
| `language-rules.md` | 按受众决定语言（开发者中文、对外英文） |
| `code-quality.md` | 五维质量门禁（正确性/安全/性能/可维护性/验证） |
| `output-style.md` | 简洁输出、请求忠实度、自审迭代 |
| `fast-path.md` | 简单任务快速路径条件与自动升级 |

**Skills（10 个技能）** — 按任务类型自动路由：

| 技能 | 触发场景 |
|------|----------|
| `develop-feature` | 新功能、端点、UI 流程、集成 |
| `fix-bug` | 缺陷、回归、崩溃、性能下降 |
| `refactor` | 结构调整、模块拆分、重写 |
| `review-code` | 代码/PR/diff 评审 |
| `architecture-review` | 架构与平台设计评估 |
| `commit-message` | 生成提交信息 |
| `answer` | 解释代码、知识问答 |
| `github` | GitHub URL/Issue/PR 集成 |
| `handoff` | 跨会话交接、上下文保存 |
| `loop-until-done` | 默认通用工作流 |

### 支持的 AI 工具

## Claude Code

复制以下指令到 Claude Code，它将完成安装：

```
Fetch and follow instructions from https://raw.githubusercontent.com/dacheng-gao/ai/main/.claude/INSTALL.md
```

升级时复制以下指令：

```
Fetch and follow instructions from https://raw.githubusercontent.com/dacheng-gao/ai/main/.claude/UPGRADE.md
```

## License

[MIT](LICENSE)
