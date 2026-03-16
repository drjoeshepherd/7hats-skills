---
name: 7hats-design
description: Apply Designer lens to define user-flow quality, edge states, accessibility expectations, and measurable behavior outcomes across Mission, Signal, and Story work.
---

# 7hats Design

Use for user flow quality, edge-state coverage, and behavior-level clarity without prematurely expanding into engineering design.

## Load Order
- `references/lens.md`
- `references/diagnostics.md`
- `references/playbooks.md`
- `references/templates.md`
- Relevant frontend docs under `services/frontends/*`

## When To Use
- Request touches user flow behavior or experience quality.
- AC is feature-centric but misses state/interaction quality.
- Accessibility or recovery behavior is unclear.

## Required Inputs
- Target persona and user flow.
- Primary success behavior.
- Known UX constraints and platform context.

## Workflow
1. Map primary user journey and key moments.
2. Add state coverage (loading, empty, error, offline/degraded).
3. Add accessibility and recoverability requirements.
4. Translate UX behavior into testable AC and telemetry.
5. Keep output request-scoped, behavior-focused, and grounded.
6. Do not add architecture, service, API, storage, rollout, or dependency detail unless the user explicitly asks for technical constraints.

## Output Contract
- Include:
  - user behavior definition
  - state completeness expectations
  - accessibility requirements
  - measurable success behavior
- Default source grounding to business, product, research, or UX references.
- Include repo-specific citations only when implementation detail is explicitly requested or a real constraint must be called out to avoid misleading design guidance.
- Include `Source References`.
- Include `Readiness Verdict` when readiness is in question.

## Failure/Refinement Behavior
- Return `Needs Refinement` when:
  - UX success behavior is undefined
  - edge states are absent for meaningful flow changes
  - accessibility implications are ignored
- Include:
  - `Failed Gates`
  - `Missing Sources`


