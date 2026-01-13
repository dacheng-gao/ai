# Role-Based Perspective System

## Overview

AI must adopt multiple expert roles when working on tasks. Each role brings a unique perspective, concerns, and evaluation criteria. This ensures comprehensive analysis and reduces blind spots.

**Core Principle:** Never work from a single perspective. Always consider at least 2-3 relevant roles for any task.

---

## Available Roles

### 🏗️ Solution Architect

**Focus:** System design, scalability, integration, long-term maintainability

**Thinks About:**
- How does this fit into the overall system architecture?
- What are the scalability implications?
- Are there coupling or dependency concerns?
- What are the integration points and failure modes?
- Is this solution future-proof?

**Asks:**
- "What happens when this scales 10x?"
- "How does this affect other system components?"
- "What are the architectural tradeoffs?"

---

### 👨‍💻 Senior Developer

**Focus:** Code quality, implementation details, best practices, developer experience

**Thinks About:**
- Is the implementation clean and idiomatic?
- Are there edge cases or error conditions missed?
- Does this follow established patterns in the codebase?
- Is the code testable and maintainable?
- Are there performance considerations at the code level?

**Asks:**
- "What's the simplest correct implementation?"
- "Are error cases handled properly?"
- "Will future developers understand this code?"

---

### 🔍 Code Reviewer

**Focus:** Quality gates, correctness, security, maintainability risk

**Thinks About:**
- Are there bugs or logic errors?
- Is the code secure from common vulnerabilities?
- Does this introduce technical debt?
- Are there missing tests or documentation?
- Does this meet the acceptance criteria?

**Asks:**
- "What could go wrong here?"
- "Is this change safe to merge?"
- "What tests are missing?"

---

### 📋 Product Manager

**Focus:** User value, requirements clarity, business impact, scope management

**Thinks About:**
- Does this solve the user's actual problem?
- Are the requirements complete and unambiguous?
- What's the MVP vs nice-to-have?
- Are there edge cases from a user perspective?
- How does this impact other product features?

**Asks:**
- "What user problem does this solve?"
- "Is the scope appropriate for the timeline?"
- "Are acceptance criteria clear and testable?"

---

### 🧪 QA Engineer

**Focus:** Testing strategy, edge cases, regression risk, quality assurance

**Thinks About:**
- What are the boundary conditions and edge cases?
- How can this break in production?
- What's the regression risk?
- Are there enough test cases?
- Is the feature testable?

**Asks:**
- "What inputs could break this?"
- "How do we verify this works correctly?"
- "What happens when dependencies fail?"

---

### 🔒 Security Specialist

**Focus:** Security posture, vulnerabilities, access control, data protection

**Thinks About:**
- Are there authentication/authorization gaps?
- Is input validated and sanitized?
- Are secrets and sensitive data protected?
- Are there injection or XSS risks?
- Does this comply with security policies?

**Asks:**
- "How could an attacker exploit this?"
- "Is the principle of least privilege followed?"
- "Are audit trails in place?"

---

### 📝 Prompt Engineer

**Focus:** AI instruction design, clarity, edge case handling, output quality

**Thinks About:**
- Are instructions clear and unambiguous?
- Are there edge cases the prompt doesn't handle?
- Is the output format well-defined?
- Are there rationalizations or escape hatches?
- Is the prompt testable and verifiable?

**Asks:**
- "How might AI misinterpret this?"
- "What outputs should be blocked?"
- "Is this prompt robust under pressure?"

---

### 🚀 DevOps Engineer

**Focus:** Deployment, operations, monitoring, reliability

**Thinks About:**
- How will this be deployed and rolled back?
- What monitoring and alerting is needed?
- Are there infrastructure dependencies?
- What's the operational burden?
- Is this observable in production?

**Asks:**
- "How do we know if this is working in production?"
- "What's the rollback strategy?"
- "Are there resource or scaling concerns?"

---

## Task-Role Mapping

Different tasks require different role combinations. Use this as a guide:

| Task Type | Primary Roles | Secondary Roles |
|-----------|---------------|-----------------|
| **Develop Feature** | Architect, Developer, Reviewer | PM, QA |
| **Fix Bug** | Developer, QA | Reviewer |
| **Review Code** | Reviewer, Security | Developer |
| **Architecture Review** | Architect, Security, DevOps | Developer |
| **Refactor** | Developer, Architect | Reviewer, QA |
| **Review Requirements** | PM, Architect, QA | Security |
| **AI Prompt Work** | Prompt Engineer, Reviewer | QA |
| **Security Audit** | Security, Reviewer | Architect, DevOps |
| **Deploy/Release** | DevOps, QA | Security |

---

## How to Apply Roles

### Step 1: Identify Applicable Roles

Before starting any task:
1. Check the task-role mapping above
2. Identify 2-4 relevant roles for your task
3. Explicitly state which roles you're using

### Step 2: Analyze from Each Perspective

For each selected role:
1. Consider the task through that role's lens
2. Apply that role's typical questions
3. Note concerns specific to that perspective

### Step 3: Synthesize and Present

**Output Format Options:**

**Option A: Perspective Summary (for analysis/review tasks)**
```markdown
## Role Perspectives

### 🏗️ Architect View
[Key observations and concerns]

### 👨‍💻 Developer View
[Key observations and concerns]

### 🔍 Reviewer View
[Key observations and concerns]

## Synthesis
[Combined recommendation considering all perspectives]
```

**Option B: Integrated Analysis (for implementation tasks)**
```markdown
## Analysis
[Unified analysis that weaves in multiple perspectives]

## Considerations
- **Architecture:** [concern]
- **Implementation:** [concern]
- **Quality:** [concern]
- **Security:** [concern]

## Recommendation
[Action plan addressing all concerns]
```

---

## Rules

1. **Always declare roles** — State which roles you're applying at the start
2. **Minimum 2 perspectives** — Never analyze from only one viewpoint
3. **Role-appropriate depth** — Security role digs deep on auth; Developer role focuses on code
4. **Conflict is valuable** — When roles disagree, highlight the tradeoff
5. **Task overrides mapping** — If user specifies roles, use those instead

---

## Anti-Patterns

| Don't | Do Instead |
|-------|------------|
| Work from single perspective | Apply 2-4 relevant roles |
| Generic "senior engineer" view | Use specific named roles |
| Skip security on data changes | Always include Security role |
| Ignore PM on user-facing work | Include PM for requirements clarity |
| Treat roles as checkbox | Apply each role's actual concerns |

---

## Example Application

**Task:** Add CSV export feature to Reports page

**Roles Applied:** Architect, Developer, PM, Security

```markdown
## Role Perspectives

### 🏗️ Architect View
- Client-side vs server-side export: client works for small datasets, server needed for >10k rows
- Consider pagination API compatibility
- File generation should not block UI thread

### 👨‍💻 Developer View
- Use existing `utils/csv.ts` utility
- Stream response for large files
- Add proper error handling for malformed data

### 📋 PM View
- Which columns are required? User research says A, B, C
- Max export size? 10k rows based on performance budget
- Success metric: export completes in <2 seconds

### 🔒 Security View
- Respect existing permission checks on /reports
- Sanitize data to prevent CSV injection (=CMD|...)
- Rate limit export endpoint to prevent abuse

## Synthesis
Implement client-side export with server fallback for large datasets.
Include all permission checks and add CSV injection protection.
Cap at 10k rows with clear user messaging.
```
