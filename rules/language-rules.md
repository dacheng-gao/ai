# 语言规则

## 概述

AI 辅助开发的语言规范。

**核心原则**
1. 聊天始终中文（回复、提问、解释）
2. 技术内容默认英文（代码、文档、git、配置等）
3. 默认不确认，直接采用默认值
4. 项目可覆盖（见 [项目级覆盖](#项目级覆盖)）

**仅在必要时确认**
- 破坏性或不可逆操作（数据删除、历史重写、破坏性迁移）
- 安全/认证或敏感数据处理变更
- 破坏 API/契约或兼容性风险
- 需求重大歧义导致范围/风险变化
- 用户明确要求确认

---

## 快速参考

| 分组 | 类别 | 默认 | 可覆盖 |
|------|------|------|--------|
| 💬 **聊天** | AI ↔ 用户对话 | **中文** | ✅ 项目级 |
| 📝 **文档** | README、ADR、指南、Wiki | 英语 | ✅ 项目级 |
| 📝 **文档** | OpenSpec 工具生成文档（如 `proposal.md` / `design.md` / `tasks.md` / `spec.md`） | 中文 | ✅ 项目级 |
| 📝 **文档** | plan 文档（如 docs/plans） | 中文 | ✅ 项目级 |
| 💻 **代码** | 注释、标识符、文件名 | 英语 | ❌ |
| 🔧 **Git 与版本控制** | 提交、PR、Issue、评审 | 英语 | ❌ |
| 🌐 **API 与 Schema** | 端点、DB schema、配置 | 英语 | ❌ |
| 🧪 **测试** | 测试名、断言、mock | 英语 | ❌ |
| 🚀 **DevOps** | CI/CD、日志、构建输出 | 英语 | ❌ |
| 📋 **变更日志** | Release notes、迁移指南 | 英语 | ✅ 项目级 |
| 🌍 **用户可见** | UI 文案、通知 | **按 Locale** | ✅ 项目级 |
| 🔑 **i18n Key** | 翻译键 | 英语 | ❌ |

---

## 分类说明（默认）

### 💬 聊天与对话（AI ↔ 用户）

**语言：** 中文（固定）
- 对话回复、提问、澄清、解释
- 聊天中的结构化输出：标题/标签/描述用中文
- 所有 agent plan 输出使用中文
- 代码、文件名、专有名词保持英文（如 `Netty`、`user_id`）

> 仅此分类默认中文，其余技术内容默认英文。

---

### 📝 文档

**默认：** 英语  
适用：README、指南、ADR、规则/技能文件、Wiki、规范文档  
**例外（默认中文）：**
- OpenSpec 工具生成文档（如 `proposal.md` / `design.md` / `tasks.md` / `spec.md`）
- plan 文档（如 docs/plans）
> 可被项目配置覆盖；默认英语无需确认。

---

### 💻 代码

**语言：** 英语（固定）  
包含注释、TODO/FIXME、标识符、文件名、常量等。

---

### 🔧 Git 与版本控制

**语言：** 英语（固定）  
**格式：** Conventional Commits — `type(scope): description`  
包含提交、分支、PR/Issue、评审、标签、里程碑。

```
feat(auth): add OAuth2 support
fix(api): handle null response
docs(readme): update installation steps
```

---

### 🌐 API 与 Schema

**语言：** 英语（固定）  
包含 API、DB schema、配置 key、OpenAPI/GraphQL 等。

---

### 🧪 测试

**语言：** 英语（固定）  
包含测试名、断言、mock、fixture 等。

---

### 🚀 DevOps 与基础设施

**语言：** 英语（固定）  
包含 CI/CD、构建/部署日志、IaC、应用日志与错误信息。

---

### 📋 变更日志与发布说明

**默认：** 英语  
包含 CHANGELOG、Release notes、迁移指南。可被项目覆盖。

---

### 🌍 用户可见消息

**语言：** 与应用 locale/受众一致  
包含 UI 文案、提示、校验、通知、帮助、Onboarding。

---

### 🔑 i18n Key（国际化键）

**语言：** 英语（固定）  
键名必须为英语；翻译值按目标语言。

```json
{
  "error.user_not_found": "用户未找到",
  "button.submit": "提交"
}
```

---

## 项目级覆盖

项目可通过 `.ai/project-rules.md` 或类似配置覆盖默认语言。

### 配置格式

```yaml
# .ai/project-config.yaml (或项目 AGENTS.md 中)
language:
  chat: chinese          # AI 对话语言（默认: chinese）
  documentation: chinese # 文档覆盖（默认: english）
  changelog: chinese     # 变更日志覆盖（默认: english）
  user_facing: chinese   # UI 文案覆盖（默认: locale-based）
```

### 覆盖优先级

1. **项目级配置** — 最高优先级
2. **用户全局规则** — `~/.ai/rules/`
3. **系统默认** — 本文件

### 覆盖行为

- 项目指定语言时直接使用，不确认
- 配置不明确或边界缺失才询问

---

## 总结

| 方面 | 语言 | 是否确认 |
|------|------|----------|
| AI 对话 | 中文 | 不确认 |
| 技术内容（代码、git、API 等） | 英语 | 不确认 |
| 文档 | 英语（OpenSpec/plan 文档默认中文，可覆盖） | 不确认 |
| 用户可见文本 | 按 locale | 遵循 i18n |

**记住：** 直接使用默认值。无需确认。项目可通过配置覆盖。
