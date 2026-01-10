# Language Rules

## Quick Reference

| # | Category | Language | Notes |
|---|----------|----------|-------|
| 1 | Chat / Conversation | Chinese | AI ↔ User dialogue |
| 2 | Documentation | English* | *Unless project specifies otherwise |
| 3 | Code comments | English | Inline, block, docstrings |
| 4 | Git commit messages | English | Conventional format |
| 5 | PR / Issue titles & body | English | GitHub/GitLab workflow |
| 6 | Code review comments | English | Technical discussion |
| 7 | User-facing messages | Locale-based | Match target audience |
| 8 | Logs & Debug output | English | Developer-facing |
| 9 | Exception / Error messages | English | Stack traces, assertions |
| 10 | Identifiers & Filenames | English | Variables, functions, paths |
| 11 | Configuration | English | Keys, env vars, YAML/JSON |
| 12 | Database schema | English | Tables, columns, indexes |
| 13 | API contracts | English | Endpoints, params, responses |
| 14 | Test names & descriptions | English | Describe behavior in English |
| 15 | CI/CD & Build output | English | Pipeline logs, scripts |
| 16 | Changelog & Release notes | English | Version history |
| 17 | i18n keys | English | Translation identifiers |

---

## Category Details

### 1. Chat & Conversation (AI ↔ User)

**Language:** Chinese 中文

- Conversational responses
- Questions and clarifications
- Explanations and reasoning
- Non-technical narrative text

---

### 2. Documentation

**Default:** English

- README, guides, specifications
- Architecture decision records (ADR)
- Rule and skill files
- Wiki pages

**Exception:** Follow project-specified language if defined. Do not ask for confirmation when using English default.

---

### 3. Code Comments

**Language:** English

- Inline comments (`// ...`, `# ...`)
- Block comments (`/* ... */`)
- JSDoc / docstrings / type annotations
- TODO / FIXME / HACK annotations

---

### 4. Git Commit Messages

**Language:** English  
**Format:** Conventional commits — `type(scope): description`

```
feat(auth): add OAuth2 support
fix(api): handle null response
docs(readme): update installation steps
refactor(db): extract connection pooling
```

---

### 5. PR / Issue Titles & Descriptions

**Language:** English

- Pull request titles and body
- Issue titles and descriptions
- Milestone and project names
- Labels and tags

---

### 6. Code Review Comments

**Language:** English

- Review comments on PRs
- Inline code suggestions
- Technical discussion threads

---

### 7. User-Facing Messages

**Language:** Match application locale / target audience

- UI text, labels, buttons
- Form validation messages
- Notifications and alerts
- Help text and tooltips
- Onboarding flows

---

### 8. Logs & Debug Output

**Language:** English

- Application logs (info, warn, debug)
- Debugging statements
- Profiling output
- Metrics and telemetry labels

---

### 9. Exception & Error Messages

**Language:** English

- Developer-facing error messages
- Stack traces and assertions
- Error codes and constants
- Deprecation warnings

---

### 10. Code Identifiers & Filenames

**Language:** English

- Variable, function, class, method names
- File and directory names
- Module and package names
- Constant and enum values

---

### 11. Configuration

**Language:** English

- Configuration keys (YAML, JSON, TOML)
- Environment variable names
- Feature flag names
- Secret and credential keys

---

### 12. Database Schema

**Language:** English

- Table and column names
- Index and constraint names
- Migration file names
- Stored procedure names

**Note:** User data follows application locale; schema stays English.

---

### 13. API Contracts

**Language:** English

- Endpoint paths (`/api/users`)
- Query and path parameters
- Request/response field names
- OpenAPI / Swagger documentation
- GraphQL schema definitions

---

### 14. Test Names & Descriptions

**Language:** English

- Test function/method names
- Test suite descriptions
- Assertion messages
- Mock and fixture names

```python
def test_user_login_with_valid_credentials():
    ...

it('should return 404 when user not found', () => { ... })
```

---

### 15. CI/CD & Build Output

**Language:** English

- Pipeline stage and job names
- Build script comments
- Deployment logs
- Infrastructure-as-code (Terraform, Ansible)

---

### 16. Changelog & Release Notes

**Language:** English

- CHANGELOG.md entries
- Release notes
- Version descriptions
- Migration guides

---

### 17. i18n Keys (Internationalization)

**Language:** English

- Translation key identifiers
- Locale file structure

```json
{
  "error.user_not_found": "用户未找到",
  "button.submit": "提交"
}
```

**Key names in English**, translated values in target locale.
