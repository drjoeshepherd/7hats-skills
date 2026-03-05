---
name: 7hats-slice-work
description: Break large Epic, Mission, or Signal scope spanning multiple services and sprints into thin vertical slices and sequenced user stories with explicit dependencies and readiness checks.
---

# 7hats Slice Work

Use this skill to decompose oversized outcomes into thin, end-to-end, shippable slices.

## Load Order
- `docs/requirements-style.md`
- `docs/definition-of-ready.md`
- `docs/tpm-agent-operating-guide.md`
- `docs/operating-system/repo-context-gate.md`
- Relevant architecture/service docs in the target implementation repository

## Workflow
1. Confirm requested boundary (`Epic`, `Mission`, `Signal`, or multi-request set).
2. Map impacted service boundaries and major dependencies.
3. Define thin vertical slice candidates by user-visible value increments.
4. Sequence slices by dependency order and risk retirement.
5. Convert slices into story-ready sequence with acceptance signals.
6. Validate slice independence, testability, and incremental release viability.

## Output Contract
- Keep output request-scoped.
- For each slice include:
  - objective and value increment
  - impacted services
  - key dependencies
  - acceptance signal
  - proposed sequence slot (sprint/release)
- Include `Source References`.
- Include `Readiness Verdict`.

## Failure/Refinement Behavior
- Return `Needs Refinement` when:
  - service boundaries are unknown
  - dependencies cannot be sequenced confidently
  - acceptance signals are not measurable
- Include:
  - `Failed Gates`
  - `Missing Sources`
  - `Corrective Actions`
