# Capability Catalog (v1)

## Purpose
Define internal capability skills used by `7hats` so user-facing interaction remains intent-first and problem-first.

## Capabilities

1. `7hats-product`
- Purpose: generate request-scoped artifacts using canonical template contracts.
- Typical outputs: Story, Bug, Customer Request, Epic, Feature, Mission, Signal, Design Spec, Research Spec.
- Internal executor hats: Product Owner primary, with Engineer/Designer/Researcher contributions when required.

2. `7hats-analyze-backlog`
- Purpose: review backlog sets (including CSV) to detect themes, ambiguity, risk, dependency conflict, and readiness gaps.
- Typical outputs: readiness findings, risk clusters, clarified scope recommendations, candidate split/merge actions.
- Internal executor hats: Researcher + Product Owner primary; Engineer for technical risk checks.

3. `7hats-slice-work`
- Purpose: break oversized Epic/Mission/Signal scope into thin vertical slices and sequenced user stories.
- Typical outputs: slice plan, story sequence, dependency-aware sprint ordering.
- Internal executor hats: Product Owner + Engineer primary; Designer when flow complexity is material.

4. `7hats-roadmap`
- Purpose: build roadmap views from slice sets and interrelated requests across services/sprints.
- Typical outputs: milestone roadmap, dependency chain, release/sprint timeline, confidence and risk markers.
- Internal executor hats: Product Owner + Entrepreneur primary; Engineer/Marketer as needed.

5. `7hats-estimate`
- Purpose: size stories/features/slices using standard agile estimation strategies.
- Typical outputs: story points, rationale, confidence, and assumptions per item.
- Default strategy: Fibonacci (`1,2,3,5,8,13,21`) when user does not specify.
- Internal executor hats: Product Owner + Engineer primary.

## Selection Hints
1. If input is one artifact request with clear type, start with `7hats-product`.
2. If input is a backlog batch or CSV, start with `7hats-analyze-backlog`.
3. If input is too large for one sprint or spans multiple services, include `7hats-slice-work`.
4. If output needs timeline/phasing across initiatives, include `7hats-roadmap`.
5. If user asks for sizing/points, include `7hats-estimate`.

## Chaining Patterns
1. Backlog triage -> artifact generation:
`7hats-analyze-backlog` -> `7hats-product`

2. Large initiative decomposition:
`7hats-analyze-backlog` -> `7hats-slice-work` -> `7hats-product`

3. Multi-service delivery planning:
`7hats-analyze-backlog` -> `7hats-slice-work` -> `7hats-roadmap` -> `7hats-product`

4. Planning with estimates:
`7hats-slice-work` -> `7hats-estimate` -> `7hats-roadmap`

## Contract Guardrail
Capabilities are internal orchestration units. Final output remains request-scoped per `skills/7hats/references/output-contracts.md`.

