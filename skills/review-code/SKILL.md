---
name: review-code
description: Use when reviewing a pull request, staged diff, patch, commit, or repository files for defects, regressions, security risks, and missing verification without implementing fixes.
---

# Review Code

Find issues that should change the merge or release decision.

## Scope

- Stay read-only. Review the exact snapshot requested: index for staged changes,
  remote head for a pull request, or the named commit, patch, or files.
- Read enough surrounding code, contracts, configuration, and tests to evaluate
  changed behavior. Do not mix unrelated worktree content into the finding.
- Prioritize correctness, security, data integrity, compatibility, reliability,
  and meaningful test gaps. Do not report style preferences as defects.

## Findings

For each issue, provide:

- severity based on realistic impact and reachability;
- a precise file and line;
- the failing scenario and consequence;
- evidence that the issue is introduced or exposed by the reviewed artifact;
- the smallest useful remediation direction.

Use `Critical` for release-blocking catastrophic or exploitable impact,
`Important` for likely incorrect behavior or material operational risk,
and `Suggestion` only for concrete low-risk improvement. Omit speculative
items that cannot be tied to an affected scenario.

## Result

Lead with findings ordered by severity. Then list only questions that affect the
verdict and summarize verification performed or missing. If there are no
material findings, say so explicitly and state the evidence boundary and
residual risk. Do not pad the review with compliments, a quality matrix, or a
fixed number of comments.
