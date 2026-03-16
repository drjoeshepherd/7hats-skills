# Fallback Standards

Use this file only when repo-aware scanning does not surface meaningful standards in the attached implementation repository.

## Baseline Source Of Truth
When fallback mode is required, `docs/operating-system/agent-coding-standards.md` remains the primary engineering standard for code review.

Apply that full baseline first, including:
- non-negotiables
- evidence rules
- standards discovery order
- architecture and design rules
- backend, frontend, data, security, reliability, testing, and change-safety rules
- code review mapping guidance
- verification expectations

This file is additive. It extends the baseline for stacks and review situations that are not covered deeply enough by the C# and Angular anchor examples.

## Fallback Review Expectations
- Keep the review request-scoped.
- Ground every claim in code or a cited standard source.
- Prioritize findings over summary.
- Focus on bugs, regressions, security issues, operability risk, and missing tests.
- Adapt baseline guidance to the target repo's language and framework conventions.
- Flag unclear behavior as `needs_refinement` rather than guessing.
- Keep style comments low priority unless they affect maintainability or violate a discovered tool rule.

## Fallback Evidence Rules
- Cite concrete files reviewed.
- Cite the standard source that justifies each standards-based finding.
- If a claim is only an inference, say so in the finding detail.
- If a baseline rule is applied through stack adaptation, say which baseline rule was adapted and why it fits the target stack.

## Severity Guide
- `critical`: security, data loss, corruption, auth, privacy, or release-blocking breakage
- `high`: likely functional bug, material regression, contract break, or missing guard on risky path
- `medium`: maintainability or reliability issue likely to cause defects soon
- `low`: minor clarity, consistency, or non-blocking test gap

## Standards Categories
- `correctness`
- `security`
- `contracts_data`
- `performance_reliability`
- `testing`
- `architecture`
- `maintainability`
- `readability`

## Language Extensions
Use these only in addition to the baseline document, never instead of it.

### JavaScript / TypeScript
- Prefer narrow types over `any`, broad `unknown` escapes, or unvalidated payload assumptions.
- Keep React, Vue, and similar UI components thin; move business logic into the repo's service, state, store, or controller layer.
- Centralize API calls in the repo's established client abstraction instead of scattering `fetch`, `axios`, or GraphQL calls through views.
- Validate external input at runtime where the repo relies on schema validation or parsing boundaries.
- Treat missing error, loading, empty, and unauthorized states as reviewable behavior gaps.

### Python
- Prefer explicit types, dataclasses, Pydantic models, or the repo's established data-shape pattern over loose dictionaries for domain-critical paths.
- Keep Flask, FastAPI, and Django views thin; push business logic into services, domain modules, or handlers when the repo follows that separation.
- Use parameterized queries or ORM-safe filters; do not approve unsafe string-built SQL.
- Watch for hidden global state, implicit settings access, and broad exception swallowing.
- Prefer pytest-style focused unit and integration coverage when the repo uses pytest.

### Java / Kotlin
- Keep controllers thin and move domain logic into services or use-case layers when the repo follows that structure.
- Prefer immutable DTOs and request models where the repo supports them.
- Respect transaction boundaries, validation layers, and exception-mapping conventions already present in the codebase.
- Watch for nullability mismatches, silent mapper drift, and unchecked collection or stream transformations on critical paths.

### Go
- Propagate `context.Context` consistently on request-scoped and I/O paths.
- Prefer explicit error handling and wrapping over silent drops or log-only failures.
- Avoid premature interface extraction; small interfaces should be justified by actual call sites or tests.
- Watch for goroutine leaks, unbounded retries, unchecked channel behavior, and shared mutable state.
- Prefer table-driven tests and focused integration coverage when those are repo norms.

### Rust
- Prefer `Result` propagation and explicit error types over `unwrap`, `expect`, or panic-prone review approvals on production paths.
- Keep ownership and borrowing choices readable; flag needless cloning or lifetime complexity that obscures correctness.
- Respect crate boundaries, feature flags, and async runtime conventions already used in the repo.
- Watch for blocking work in async paths, unchecked `unsafe`, and serialization contract drift.

## Residual Reporting
- If no material findings exist, still report testing gaps and residual risks when present.
- If tests were not run or cannot be inferred, say so in `testing_gaps`.
- Lower review confidence when fallback standards had to be adapted heavily without repo-local corroboration.
