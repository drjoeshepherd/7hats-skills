# Intent Taxonomy (v2)

## Purpose
Define a small, user-facing intent vocabulary so TPMs can ask for outcomes while the system internally selects capability skills.

## Public Intents

1. `clarify`
- Goal: convert vague asks into bounded, testable backlog artifacts.
- Typical use: early refinement, unclear scope, missing measurable outcome.
- Primary capabilities: `7hats-product`, `7hats-analyze-backlog`.
- Default artifacts: Story, Mission, Signal.

2. `plan`
- Goal: create executable sequencing and decomposition.
- Typical use: mission breakdown, sprint slicing, dependency ordering.
- Primary capabilities: `7hats-slice-work`, `7hats-roadmap`.
- Default artifacts: Story series, Story, Mission.

3. `de-risk`
- Goal: identify and retire major technical, delivery, and adoption risks.
- Typical use: pre-launch, migration, multi-service integration.
- Primary capabilities: `7hats-analyze-backlog`, `7hats-product`.
- Default artifacts: Story, Mission, Signal.

4. `decide`
- Goal: force explicit tradeoff and decision criteria.
- Typical use: competing options, repeated arguments, unresolved ownership.
- Primary capabilities: `7hats-product`.
- Default artifacts: Story or Mission (decision-ready framing).

5. `validate`
- Goal: run readiness and grounding checks before commitment.
- Typical use: pre-sprint or pre-approval quality gate.
- Primary capabilities: `7hats-analyze-backlog`, `7hats-product`.
- Default artifacts: same type as input request; may return `Needs Refinement`.

6. `recover`
- Goal: restore clarity and momentum when execution drifts.
- Typical use: rising meetings, low decision velocity, repeated blockers.
- Primary capabilities: `7hats-roadmap`, `7hats-analyze-backlog`.
- Default artifacts: Story, Signal, or Mission update.

## Intent Parsing Rules
1. If user explicitly states one of the six intents, use it.
2. If user does not state intent, infer best-fit from request text.
3. If intent confidence is low, default to `clarify`.
4. If artifact type is explicitly requested, preserve it.
5. If artifact type is ambiguous, default to Story.

## Contract Guardrails
1. Intents are user-facing only through `7hats`.
2. Intents do not change output contracts.
3. Final output must remain request-scoped:
- Story only
- Mission only
- Signal only
- Mission/Signal breakdown to story series only

## Readiness Behavior
When required context is missing:
- Set `Readiness Verdict: Needs Refinement`
- Include `Failed Gates`
- Include `Missing Sources`

## Source Of Truth
- `docs/requirements-style.md`
- `docs/definition-of-ready.md`
- `docs/operating-system/capability-catalog.md`
- `skills/7hats/references/output-contracts.md`

