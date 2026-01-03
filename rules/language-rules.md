# Language Rules

## Response Language
- All conversational responses in **Chinese**
- Ask questions in **Chinese**
- Explanations, reasoning, and any non-technical narrative text in **Chinese**
- No auto-generated markdown summaries

## Document Language
- When generating documents, you may use the user-specified language.
- Default to **English** and ask for confirmation before producing a non-English document.

## Code & Technical Artifacts
All technical artifacts and technical content in **English**:
- Code, comments, identifiers
- File and directory names
- Git commits (use conventional format: `type(scope): description`)
- Branch names, PR titles/descriptions
- Documentation, README, rules, and skills files (except user-confirmed document generation language)
- Logs, error messages, stack traces, configuration snippets, and command output excerpts
