# Language Rules

## Overview

This document defines language conventions for AI-assisted development.

**Core Principles:**
1. **Chat language is ALWAYS Chinese (中文)** — AI responses, questions, explanations
2. **Default technical language is English** — code, docs, git, configs
3. **No confirmation needed** — use defaults directly without asking
4. **Project overrides allowed** — see [Configuration](#project-level-override) section

**Confirmation Exceptions (only when necessary):**
- Destructive or irreversible actions (data deletion, history rewrite, breaking migrations)
- Security/auth or sensitive data handling changes
- Breaking API/contract changes or compatibility risks
- Ambiguous requirements that materially change scope or risk
- User explicitly requests confirmation

---

## Quick Reference

| Group | Categories | Default | Override Allowed |
|-------|------------|---------|------------------|
| 💬 **Chat** | AI ↔ User dialogue | **Chinese** | ✅ Project |
| 📝 **Documentation** | README, ADR, guides, wikis | English | ✅ Project |
| 💻 **Code** | Comments, identifiers, filenames | English | ❌ |
| 🔧 **Git & VCS** | Commits, PRs, issues, reviews | English | ❌ |
| 🌐 **API & Schema** | Endpoints, DB schema, configs | English | ❌ |
| 🧪 **Testing** | Test names, assertions, mocks | English | ❌ |
| 🚀 **DevOps** | CI/CD, logs, build output | English | ❌ |
| 📋 **Changelog** | Release notes, migration guides | English | ✅ Project |
| 🌍 **User-Facing** | UI text, notifications | **Locale-based** | ✅ Project |
| 🔑 **i18n Keys** | Translation identifiers | English | ❌ |

---

## Category Details

### 💬 Chat & Conversation (AI ↔ User)

**Language:** Chinese 中文 (固定)

Applies to:
- Conversational responses
- Questions and clarifications
- Explanations and reasoning
- **Structured output within chat** (Plans, Checklists, Analysis Reports)
  - **Headers, Labels, Descriptions**: Chinese (e.g., "Risk Level", "Impact")
  - **Code, Filenames, Proper Nouns**: English (e.g., `Netty`, `user_id`)
- Non-technical narrative text

> **Note:** This is the ONLY category that defaults to Chinese. All other technical content defaults to English.

---

### 📝 Documentation

**Default:** English

Applies to:
- README files and guides
- Architecture decision records (ADR)
- Rule and skill files
- Wiki pages and specifications

> **Override:** Projects may specify another language. When using English default, do NOT ask for confirmation.

---

### 💻 Code

**Language:** English (固定)

Includes:
- **Comments:** Inline (`//`, `#`), block (`/* */`), docstrings
- **Annotations:** TODO, FIXME, HACK, type hints
- **Identifiers:** Variables, functions, classes, methods
- **Filenames:** Files, directories, modules, packages
- **Constants:** Enum values, magic strings

---

### 🔧 Git & Version Control

**Language:** English (固定)  
**Format:** Conventional commits — `type(scope): description`

Includes:
- Commit messages
- Branch names
- PR/Issue titles and descriptions
- Code review comments
- Labels and milestones

```
feat(auth): add OAuth2 support
fix(api): handle null response
docs(readme): update installation steps
```

---

### 🌐 API & Schema

**Language:** English (固定)

Includes:
- **API:** Endpoint paths, query params, request/response fields
- **Database:** Table/column names, indexes, migrations
- **Config:** YAML/JSON/TOML keys, env vars, feature flags
- **OpenAPI/Swagger/GraphQL:** Schema definitions

---

### 🧪 Testing

**Language:** English (固定)

Includes:
- Test function/method names
- Test suite descriptions
- Assertion messages
- Mock and fixture names

```python
def test_user_login_with_valid_credentials():
    ...
```

```javascript
it('should return 404 when user not found', () => { ... })
```

---

### 🚀 DevOps & Infrastructure

**Language:** English (固定)

Includes:
- CI/CD pipeline stages and job names
- Build scripts and deployment logs
- Infrastructure-as-code (Terraform, Ansible)
- Application logs (info, warn, debug)
- Error messages, stack traces, assertions

---

### 📋 Changelog & Release Notes

**Default:** English

Includes:
- CHANGELOG.md entries
- Release notes and version descriptions
- Migration guides

> **Override:** Projects targeting non-English audiences may specify another language.

---

### 🌍 User-Facing Messages

**Language:** Match application locale / target audience

Includes:
- UI text, labels, buttons
- Form validation messages
- Notifications and alerts
- Help text and tooltips
- Onboarding flows

> **Note:** This category is locale-dependent. Follow the application's i18n strategy.

---

### 🔑 i18n Keys (Internationalization)

**Language:** English (固定)

Key names MUST be English. Translated values follow target locale.

```json
{
  "error.user_not_found": "用户未找到",
  "button.submit": "提交"
}
```

---

## Project-Level Override

Projects can override default languages by creating a `.ai/project-rules.md` or similar config file.

### Configuration Format

```yaml
# .ai/project-config.yaml (or in project AGENTS.md)
language:
  chat: chinese          # AI conversation language (default: chinese)
  documentation: chinese # Override for docs (default: english)
  changelog: chinese     # Override for release notes (default: english)
  user_facing: chinese   # Override for UI text (default: locale-based)
```

### Override Priority

1. **Project-level config** — highest priority
2. **User global rules** — `~/.ai/rules/`
3. **System defaults** — this file

### Behavior on Override

- When a project specifies a language, use it **without asking for confirmation**
- Only ask for clarification if the project config is ambiguous or missing for an edge case

---

## Summary

| Aspect | Language | Confirmation |
|--------|----------|--------------|
| AI Chat | Chinese 中文 | Never ask |
| Technical (code, git, API, etc.) | English | Never ask |
| Documentation | English (or project override) | Never ask |
| User-facing text | Locale-based | Follow project i18n |

**Remember:** Use defaults directly. No confirmation dialogs. Projects can override via config.
