---
name: 7hats-code-review
description: Review pull requests, diffs, commits, or repository changes for bugs, regressions, standards drift, and missing tests. Use when users ask for a code review, PR review, diff review, standards compliance review, or repo-aware engineering findings with JSON-only output.
---

# 7hats Code Review

Use this skill for findings-first code review with explicit standards discovery and a strict JSON output contract.

## Load Order
- `docs/operating-system/agent-coding-standards.md`
- `docs/operating-system/paired-coding-charter.md`
- `references/standards-discovery.md`
- `references/fallback-standards.md`
- `references/review-output.schema.json`
- `AGENTS.md`
- `docs/requirements-style.md`
- Relevant standards and implementation files in the target repository

## Workflow
1. Detect execution context:
- `Repo-Aware Mode`: a target implementation repository is attached.
- `Fallback Mode`: no target repository standards can be found; use this bundle's baseline standards.
2. Determine review scope from the user request:
- requested files
- current diff or PR scope
- commit range
- repo slice when no narrower scope exists
3. In `Repo-Aware Mode`, scan the attached repository for standards before reviewing code:
- `AGENTS.md`
- coding standards docs and pairing/review charters
- `CONTRIBUTING.md`
- `README*`
- docs covering architecture, coding conventions, testing, security, or review policy
- CI files and review gates under `.github/*`, `.gitlab-ci*`, `azure-pipelines*`
- formatter/linter/type-check configs
- test runner configs and package/build manifests
4. Classify standards as:
- `explicit`: directly documented expectations
- `inferred`: conventions evidenced by tooling or tests
5. If no meaningful repository standards are found, load `references/fallback-standards.md` and use this repo's baseline expectations.
6. Adapt standards to the target stack:
- enforce the intent of the rule, not literal C# or Angular syntax
- prefer repo-local patterns over generic language advice
7. Review the requested change set with findings-first priority:
- correctness bugs
- behavioral regressions
- security/privacy issues
- contract and data integrity
- reliability/performance risks
- missing or weak tests
- maintainability/readability issues that materially affect change safety
- standards violations grounded in discovered sources
8. Return one JSON object only, matching `references/review-output.schema.json`.

## Output Contract
- Return JSON only. Do not wrap in Markdown fences.
- Match `references/review-output.schema.json`.
- Include `verified_facts`, `assumptions`, `testing_gaps`, and `verification_steps`.
- Order findings by severity, then file, then line.
- Every finding must include:
  - primary standards category
  - severity
  - title
  - file path
  - line when identifiable
  - why it matters
  - evidence grounded in reviewed code or standards sources
- Include `applied_standards` showing whether each standard came from the target repo or fallback bundle, and which standards categories it informs.
- If no material findings exist, return:
  - `findings: []`
  - a concise `summary`
  - any residual `testing_gaps` or `residual_risks`

## Failure/Refinement Behavior
- Return `verdict: "needs_refinement"` when:
  - review scope is ambiguous
  - required files or diff context are unavailable
  - standards cannot be grounded well enough for a defensible review
- Include:
  - `failed_gates`
  - `missing_sources`
  - `open_questions`
