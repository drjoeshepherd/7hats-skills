# Requirements Style Guide

This guide defines how agents should produce clear, implementation-ready requirements that are directly traceable to business outcomes.

## Core Operating Model
- Work with an owner mindset: translate market inputs and strategy into scoped execution work.
- Ground all requirements in current docs and architecture before proposing changes.
- Prefer incremental, low-risk slices (for example, V1 bets) over broad, single-phase delivery.
- Apply foundational TPM thinking from `docs/the-7-hats-foundation.md`.

## 7 Hats Foundation (Required)
- Treat `docs/the-7-hats-foundation.md` as foundational guidance for Product Owner and TPM reasoning.
- Use hat-switching logic to match the current constraint:
  - Ambiguity -> Researcher
  - Backlog clarity -> Product Owner
  - User friction -> Designer
  - System risk -> Engineer
  - Adoption risk -> Marketer
  - Portfolio/capital trade-offs -> Entrepreneur
  - Team health/decision quality -> Meta
- Keep outputs concise, but make trade-offs and constraints explicit.

## Grounding Gate (Required)
- Every story must cite at least 2 concrete repo references:
  - One architecture/service document (for example under `architecture/*` or `services/*`).
  - One mapping or implementation reference (for example `mappings/repo-map.md` and/or validated code location).
- Add a dedicated `Source References` section in every output.
- If a required source cannot be found, include `Unknown - needs discovery` and mark readiness as `Needs Refinement`.

## No-Assumption Rule
- If a requirement says "same as X" or "parity with X", validate how `X` currently works from docs/code before writing acceptance criteria.
- Do not infer behavior without citation. If validation is missing, return `Needs Refinement` with missing sources listed.

## Language And Clarity Standard
- Write in plain, direct English.
- Assume English is a second language for many readers (native language: Serbian).
- Prefer short sentences, concrete terms, and explicit field labels over dense narrative text.

## Backlog Hierarchy And Required Fields

Use this hierarchy for all planning artifacts:

1. `Signal`
- External input (market event, customer ask, support pattern, usage data trend).
- Must include:
  - `Problem Statement` (255 characters max)
  - `Why Now/Urgency`
  - `Desired Outcome`
  - `Success Metrics`
  - `Primary Hat Lens` (from the 7 Hats) and reason

2. `Mission`
- Strategic product or architecture bet that changes capability or platform direction.
- Must include:
  - `Problem Statement` (255 characters max)
  - `Desired Outcome`
  - `Success Metrics`
  - `Scope Boundary` (what is explicitly out of scope)
  - `Primary Hat Lens` (from the 7 Hats) and reason
  - `Bet Framing` (hypothesis, minimum proof, kill criteria)

3. `Story`
- Tactical implementation unit linked to a parent Signal or Mission when possible.
- Must include:
  - `Title` (`[System Area] Clear Summary`; story form may use `As a <Role>, I want <Goal>`)
  - `Context/Origin` (optional; reference Signal or Mission only when provided/required)
  - `Scope`
  - `Out of Scope`
  - `Assumptions`
  - `Dependencies`
  - `Description` (concise supporting context)
  - `Acceptance Criteria`
  - `Estimate` (XS=1, S=2-3, M=5, L=8, XL=13; break down XXL=21+)
  - `Priority` (required for top-level items)
  - `QA Evidence` field placeholder (for validation traceability)
  - `Technical Notes`
  - `Source References`

4. `Customer Request`
- Tactical unit similar to a Story, but sourced directly from a paying white-label tenant.
- Must include the same fields as `Story`, plus:
  - `Tenant Context` (who asked, relevant contract/SLA constraints if known)

Standalone operational Stories are allowed when no parent Signal or Mission exists. Mark them as `Operational`.

## Work Item Separation Rules (Required)
- `Mission`, `Signal`, and `Story` are different backlog levels and must not be merged in one artifact unless explicitly requested.
- A `Mission` or `Signal` may contain many stories.
- A `Story` may be standalone and does not require a parent Mission/Signal.
- Do not auto-generate Mission/Signal content when the user asks only for a Story.

## Request-Scoped Output Rules (Required)
- If user asks for a `Story`/`User Story`, return only the story artifact.
- If user asks for a `Mission`, return only the mission artifact.
- If user asks for a `Signal`, return only the signal artifact.
- If user asks to break down a Mission/Signal, return only the required series of stories.
- Include only fields relevant to the requested work item type.

## Mission/Signal Planning Lens (Required)
- For Mission/Signal outputs, explicitly apply 7 Hats concepts:
  - Product Owner: measurable value and prioritization rationale.
  - Researcher: uncertainty/hypothesis and evidence threshold.
  - Engineer: primary system constraint and key risks.
  - Entrepreneur: bet framing and kill criteria.
- For Story-only requests, do not force Mission/Signal fields; use hat concepts implicitly for quality.

## Story Quality Standard (INVEST)
- `Independent`: Can be delivered and validated without hidden coupling.
- `Negotiable`: States outcome and constraints, not rigid implementation.
- `Valuable`: Clear user or business value.
- `Estimable`: Scope is concrete enough to size.
- `Small`: Fits a single sprint or equivalent delivery window.
- `Testable`: Acceptance criteria are objectively verifiable.

## Acceptance Criteria Standard
- Preferred: Gherkin (`Given/When/Then`).
- Allowed: concise, testable bullet criteria when Gherkin adds noise.
- Focus criteria on observable behavior and outcome, not internal implementation details.
- Include negative/error paths when they materially affect user behavior or risk.
- Prefer 3-7 criteria; more usually indicates oversized scope.
- Anything not covered by AC is out of scope unless explicitly stated.

## Definition Of Ready Integration
- Use `docs/definition-of-ready.md` as the readiness gate before sprint commitment.
- Treat item-level `Definition of Done` as optional by default; project-level DoD governs completion unless a board/workflow explicitly requires item-level DoD.
- If any readiness condition fails (business context, technical context, or validation clarity), return the item for refinement.
- Treat the DoR checklist in `docs/definition-of-ready.md` as canonical to avoid checklist drift.

## Required Preflight Block
- Every output must include:
  - `Readiness Verdict: Ready | Needs Refinement`
  - `Failed Gates:` list required when verdict is `Needs Refinement`
  - `Missing Sources:` list required when grounding is incomplete

## Technical Notes Standard
Capture implementation-impact hints without over-prescribing design:
- API contract changes (request/response, versioning, auth, error model)
- Data changes (T-SQL/NoSQL schema, migration/backfill expectations)
- Azure impact (services, networking, identity, deployment implications)
- Dependencies and sequencing constraints

## NFR Coverage Expectations
Every non-trivial requirement should include NFR impact across:
- Security and compliance (SOC 2 mindset, least privilege, auditability)
- Scalability and performance (expected load, latency or throughput considerations)
- Reliability and operability (failure modes, retries, observability)

## Decomposition Guidance
- Break broad Missions into thin vertical slices that can be validated early.
- Recommend phased rollout (`V1`, `V1.1`, `V2`) when uncertainty or risk is high.
- Flag inconsistencies when requested behavior conflicts with current architecture or service boundaries.
- Flag high-friction work (high effort + low urgency) and oversized items for further breakdown.

## Parity Tracking Checklist
Use this checklist for "treat X like Y" tracking requests:
- Event names and trigger points are mapped for both entities.
- Event payload/schema parity is defined, including entity discriminator.
- Completion and interest lifecycle states are aligned.
- Analytics/reporting parity is defined (same surfaces, filters, and visibility expectations).
- Backward compatibility is confirmed for existing tracked entity behavior.

## Self-Score Rubric (Required)
- Score each output before finalizing.
- Structure compliance: 30%
- Repo grounding and citations: 40%
- Acceptance criteria testability: 20%
- Clarity and ESL readability: 10%
- Minimum passing score: 8/10. If lower, return `Needs Refinement` and explain gaps.


