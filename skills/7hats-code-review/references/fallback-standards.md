# Fallback Standards

Use this file only when repo-aware scanning does not surface meaningful standards in the attached implementation repository.

## Baseline Review Expectations
- Keep the review request-scoped.
- Ground every claim in code or a cited standard source.
- Prioritize findings over summary.
- Focus on bugs, regressions, security issues, operability risk, and missing tests.
- Adapt C# and Angular examples to the target repo's language and framework conventions.
- Flag unclear behavior as `needs_refinement` rather than guessing.
- Keep style comments low priority unless they affect maintainability or violate a discovered tool rule.

## Baseline Evidence Rules
- Cite concrete files reviewed.
- Cite the standard source that justifies each standards-based finding.
- If a claim is only an inference, say so in the finding detail.

## Baseline Severity Guide
- `critical`: security, data loss, corruption, auth, privacy, or release-blocking breakage
- `high`: likely functional bug, material regression, contract break, or missing guard on risky path
- `medium`: maintainability or reliability issue likely to cause defects soon
- `low`: minor clarity, consistency, or non-blocking test gap

## Baseline Standards Categories
- `correctness`
- `security`
- `contracts_data`
- `performance_reliability`
- `testing`
- `architecture`
- `maintainability`
- `readability`

## Baseline Residual Reporting
- If no material findings exist, still report testing gaps and residual risks when present.
- If tests were not run or cannot be inferred, say so in `testing_gaps`.
