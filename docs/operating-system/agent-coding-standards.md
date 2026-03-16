# Career Highways - AI Agent Coding Standards

> Purpose: Define the default engineering bar for autonomous or semi-autonomous AI agents that generate or review code in repositories.
> Goal: Produce changes and reviews that are correct, minimal, secure, readable, verifiable, and maintainable at a principal engineer bar.

---

## Verification Metadata
- Last Verified: 2026-03-13
- Source Repos: `C:\Projects\career-highways-agent-docs`
- Owner: Engineering Enablement

## 0) Non-Negotiables

- Do not invent. Never claim an endpoint, type, handler, table, config, workflow, or policy exists unless you can point to it in the repo.
- Correctness over completeness. If you cannot verify a critical fact, stop and provide verification steps instead of guessing.
- Smallest safe change wins. Prefer additive, backward-compatible changes; avoid churn and speculative refactors unless explicitly requested.
- Human-first code. Code must be easy to read and modify. Avoid cleverness, excessive abstraction, and needless indirection.
- Security always. Never output secrets. Never weaken auth. Never concatenate SQL. Never move enforcement to the client when the server must own it.
- Standards discovery first. Before changing or reviewing code, discover repo-local standards and use them ahead of generic advice.

## 1) Portability Rule

These standards were originally written around C# services and Angular UI. Treat those examples as anchor patterns, not language-locked rules.

When working in another stack, adapt the intent rather than copying syntax:
- C# `record` guidance means prefer immutable or intentionally constrained data shapes in the target language.
- Angular service/component separation means keep UI layers thin and move business logic into the repo's established state, service, or controller layer.
- Dapper parameterization guidance means use the target repo's approved safe data-access mechanism.
- Decorator guidance means use the stack's equivalent middleware, filters, interceptors, wrappers, or pipeline behaviors.
- Jasmine/Karma guidance means use the repo's actual test framework and structure.

If the target repo has stronger or more specific standards, those override these defaults.

## 2) Evidence Rules (Required)

When you write plans, guidance, reviews, or code notes, classify claims:

- `Verified`: grounded in an observed file path and, when possible, symbol or config key
- `Inferred`: derived from repeated repo patterns or tooling, but not explicitly documented
- `Needs verification`: required fact is not yet confirmed

If a decision depends on an unverified fact, you MUST:
1. Mark it as needing verification.
2. Give exact steps to verify it.
3. Avoid dependent implementation or review conclusions that assume it is true.

## 3) Standard Working Structure

For non-trivial implementation work, separate:
1. Verified facts
2. Assumptions
3. Inferred design or recommendations
4. Risks and edge cases
5. Test plan
6. Verification steps

For code review output, use the review JSON contract, but preserve the same separation through structured fields rather than prose sections.

## 4) Standards Discovery Order

Before implementing or reviewing, search in this order:

1. Direct repo instructions
- `AGENTS.md`
- contribution guides
- coding standards docs
- code review or pairing charters

2. Architecture and operating docs
- service boundaries
- ADRs
- runbooks
- deployment and security guidance

3. Tool-enforced conventions
- formatter configs
- linter configs
- type-check configs
- static analysis rules
- CI quality gates
- test runner configs

4. Local implementation patterns
- neighboring files in the same module
- existing tests in the affected area
- repeated naming, validation, error handling, and data-access patterns

Prefer explicit standards over inferred standards. Prefer tool-enforced standards over stylistic preference.

## 5) Architecture and Design Rules

- Preserve established boundaries. Do not collapse domain, transport, persistence, and presentation concerns into one unit.
- Keep orchestration thin. Handlers, controllers, resolvers, and components should coordinate work, not own all business logic.
- Prefer validity by construction when the language and repo patterns support it.
- Keep contracts stable. Extend or version instead of silently breaking consumers.
- Make side effects visible. Writes, remote calls, caching, retries, and transaction boundaries should be easy to identify.
- Design for deletion. New abstractions must justify their cost by reducing repeated complexity or risk.

## 6) Backend and Service Rules

Apply these rules to APIs, workers, jobs, and server-side services in any language.

- Prefer explicit domain types over bags of loosely related primitives when the repo already models the domain.
- Centralize validation at the repo's normal boundary layer.
- Keep handlers, controllers, and endpoints thin; delegate business rules to domain or service layers.
- Use the repo's established mechanism for cross-cutting concerns such as logging, retries, caching, transactions, and authorization.
- Parameterize all queries and commands. Never build SQL or equivalent data queries through unsafe string concatenation.
- Catch exceptions only to translate, redact, or enrich them at the correct boundary.
- Normalize success and error responses using the repo's established response contract.
- Respect cancellation, timeouts, idempotency, and retry behavior where the repo already models them.

### 6.1 C# Notes
- Prefer `record` or other immutable shapes where appropriate.
- Avoid mutable request DTOs unless the repo explicitly relies on them.
- Follow the service's established mediator, pipeline, result, and exception patterns.

## 7) Frontend and UI Rules

Apply these rules to Angular and other frontend stacks.

- Keep components or views thin; move business logic into the repo's established service, state, store, or controller layer.
- Centralize API access in the repo's normal abstraction layer.
- Respect existing auth, interceptor, routing, and guard patterns.
- Handle loading, empty, error, and unauthorized states intentionally.
- Preserve accessibility expectations for focus, semantics, keyboard use, contrast, and announcement behavior.
- Avoid coupling UI assumptions to unstable backend behavior; confirm payload shape and error contracts.

### 7.1 Angular Notes
- Avoid calling `HttpClient` from components when the repo uses services for API access.
- Prefer existing routed-module or standalone-component conventions already present in the repo.
- Use the repo's existing Angular test structure and tooling.

## 8) Data, Contracts, and Integration Rules

- Do not change schemas lightly. Keep DB and event changes minimal and provide safe migration expectations.
- Confirm the system of record before duplicating or transforming domain data.
- Preserve tenant, organization, and authorization boundaries server-side.
- Be explicit about contract changes to APIs, messages, or stored data.
- Consider backward compatibility for old clients, jobs, and scheduled processes.

## 9) Security and Secret Handling

- Never introduce secrets, tokens, private keys, or credentials into code, config, tests, or examples.
- Do not weaken auth, auditing, or permission checks.
- Minimize data exposure in logs, errors, and telemetry.
- Treat file upload, deserialization, redirect, HTML rendering, and external-call paths as risk surfaces.

## 10) Reliability, Performance, and Operability

- Avoid repeated expensive calls in loops or hot paths.
- Consider pagination, bounds, batching, and timeouts for list or search operations.
- Keep retries intentional and bounded.
- Log meaningfully at boundaries and failures without flooding logs.
- Maintain observable behavior through metrics, traces, or structured logs when the repo already supports them.
- Prefer deterministic behavior over hidden background coupling.

## 11) Testing Rules

Every meaningful change should include tests or a justified reason why not.

### 11.1 Minimum Coverage Expectations
- Unit tests for core logic, validation, and key edge cases
- Integration or contract tests for wiring, auth, persistence, and API shape when relevant
- Regression coverage for bugs that were fixed

### 11.2 Stack Adaptation
- C# services: unit-test request validity and handler behavior; integration-test routes, auth scope, and data access behavior
- Angular: test services and state behavior first; keep component tests focused and minimal
- Other stacks: use the repo's standard testing layers, but preserve the same intent

If tests are not added, state why and give the smallest meaningful manual verification steps.

## 12) Change Safety Checklist

Before finalizing a patch or review:

- [ ] Repo-specific facts are verified where they matter.
- [ ] No secrets or sensitive data are introduced.
- [ ] Auth and tenant or org scoping remain enforced server-side.
- [ ] Queries and data access paths are safe and parameterized.
- [ ] Changes are minimal and backward-compatible, or the break is explicit.
- [ ] Tests are added or a defensible reason is documented.
- [ ] The result is readable, consistent, and maintainable.

## 13) Code Review Mapping (7hats Code Review)

When a structured code review is requested, use `7hats-code-review` and map the review to these standards as follows:

- `applied_standards`: every standards source used for the review, marked as `target_repo` or `fallback_bundle`, with explicit or inferred strength and the standards categories it informs
- `scorecard`: standards-based dimension scores grounded in verified evidence, with confidence and `cannot_score_reason` when evidence is insufficient
- `metrics`: review coverage and finding counts used to interpret the scorecard
- `human_readable_report`: executive summary, top findings, score highlights, and next actions rendered from the same review object
- `verified_facts`: concrete facts observed in code, config, docs, tests, or diff context
- `assumptions`: bounded assumptions that did not rise to verified facts
- `findings[].category`: one primary standards category such as correctness, security, testing, maintainability, performance_reliability, contracts_data, architecture, or readability
- `findings[].standards_sources`: source files or standards documents that justify the finding
- `testing_gaps`: missing validation, missing regression coverage, or unrun critical checks
- `residual_risks`: known risks that remain even if no blocking finding exists
- `verification_steps`: exact commands or inspections needed when a fact could not be verified
- `missing_sources` and `failed_gates`: used when the review cannot be defended to principal engineer bar

Review findings should emphasize:
1. correctness and regressions
2. security and authorization
3. contract and data integrity
4. reliability and operability
5. missing tests
6. maintainability and readability

Scoring should remain secondary to findings:
- never let a strong score offset a blocking finding
- score only what was actually reviewed and evidenced
- lower confidence when standards or implementation evidence are weak

## 14) If You Are Not Sure

If you cannot verify a required fact:
- Stop implementation or lower review confidence accordingly.
- Output only what is verified, what must still be verified, and exact steps to do so.
- Do not guess hidden behavior.

## 15) Verification Commands (Suggested)

Use repo-appropriate commands like:

- Search:
  - `rg "MapGet|MapPost|MapGroup" -n`
  - `rg "\\[ApiController\\]|\\[Http(Get|Post|Put|Delete)" -n`
  - `rg "Dapper|QueryAsync|ExecuteAsync" -n`
  - `rg "ServiceResult|Result<|ApiResponse" -n`
  - `rg "Authorize|Policies|scope|organizationId|tenant" -n`
  - `rg "HttpClient|fetch\\(|axios|graphql" -n`
  - `rg "describe\\(|it\\(|test\\(|pytest|xunit|nunit" -n`

- Build and test:
  - .NET: `dotnet build`, `dotnet test`
  - Angular: `npm test`, `ng test`, `ng build`
  - Adapt to the repo's actual scripts once verified

## 16) Definition of Done

A change or review is done only when:

- Correct behavior is implemented or evaluated against repo patterns
- Standards are grounded in repo evidence or explicitly marked as fallback defaults
- Tests exist, pass, or the gap is clearly justified
- No avoidable contract-breaking or security regression is introduced
- Code and recommendations are maintainable at a principal engineer bar
- Verification steps are documented whenever uncertainty remains
