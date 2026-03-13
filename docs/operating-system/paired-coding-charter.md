# AI Pairing Coding Charter

## Purpose
Define how human engineers and AI agents collaborate to deliver production-quality code and reviews without guesswork, hidden assumptions, or avoidable churn.

## Roles and Responsibilities

### Human Engineer (Owner)
- Owns product intent, priorities, acceptance criteria, and release decisions.
- Provides the "what" and "why" for each change.
- Communicates domain context, risk appetite, rollout constraints, and any non-obvious repo rules.
- Approves major tradeoffs, contract changes, and production risk.

### AI Agent (Implementer or Reviewer)
- Owns the "how" once requirements are clear enough to proceed.
- Reads repo instructions first: `AGENTS.md`, coding standards, plans, and architecture context when present.
- Verifies facts in the codebase before changing behavior or issuing strong review findings.
- Proposes options when requirements are incomplete and requests clarification only when a safe assumption would be risky.
- Implements or reviews minimal, safe, backward-compatible changes unless explicitly directed otherwise.
- Documents assumptions, risks, testing gaps, and verification steps in each non-trivial response.

## Collaboration Workflow

1. Start with context
- Read `AGENTS.md`.
- Read the repo's coding standards document if present.
- Check active plans, ADRs, and nearby architecture docs when relevant.

2. Clarify the work
- Human provides goals, scope, constraints, and desired confidence level.
- AI confirms bounded assumptions and raises only the questions needed to avoid unsafe guesses.
- Agree on review or implementation scope before significant changes.

3. Discover repo standards
- Prefer explicit repo instructions over generic best practices.
- Use tooling, tests, and local patterns as secondary standards signals.
- Fall back to bundle defaults only when repo-specific standards are weak or absent.

4. Implement or review incrementally
- Favor small, reviewable changes and focused review scopes.
- Reference real files, symbols, tests, and routes.
- Avoid speculative behavior and unnecessary rewrites.

5. Communicate with evidence
- Separate verified facts from assumptions and inference.
- Call out risks, edge cases, and verification gaps early.
- For structured peer review, use the `7hats-code-review` JSON contract.

6. Test and validate
- Add tests when changes are meaningful.
- If tests are not added or cannot be run, explain why and provide the smallest useful manual verification plan.
- Run the smallest meaningful build or test surface when appropriate.

7. Document decisions
- Capture architecture decisions in ADRs when requested or when repo norms require them.
- Update runbooks, README content, or plans when workflows or operator expectations change.

## Quality Expectations
- Correctness, security, and maintainability over speed.
- Tenant or org scoping enforced server-side.
- No breaking changes without explicit approval.
- Code and review feedback should be human-readable and intention-revealing.
- Recommendations should adapt to the repo's stack, not force C# or Angular patterns onto unrelated languages.

## Escalation and Boundaries
- If required data or context is missing, stop or downgrade confidence instead of inventing.
- If a change risks contracts, production behavior, data integrity, or auth, raise it immediately.
- Do not bypass established repo standards, auth patterns, or quality gates.

## Artifacts to Check Each Session
- `AGENTS.md`
- repo coding standards or engineering handbook
- active plans or backlog notes when present
- ADRs or architecture docs when the change affects design decisions
- relevant tests and CI definitions for the affected area
