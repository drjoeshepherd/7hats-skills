---
name: 7hats-engineer
description: Apply Engineer lens to map system constraints, dependencies, non-functional requirements, and technical risk retirement for Mission, Signal, and Story planning.
---

# 7hats Engineer

Use for architecture constraints, NFR quality, and technical risk retirement.

## Load Order
- `references/lens.md`
- `references/diagnostics.md`
- `references/playbooks.md`
- `references/templates.md`
- `docs/requirements-style.md`
- Relevant service docs under `services/backends/*` and `services/frontends/*`

## When To Use
- Mission introduces technical or architectural change.
- Signal implies service boundary or reliability risk.
- Story needs NFR and rollback clarity.

## Required Inputs
- Target outcome and traffic/usage expectation.
- Known architecture boundaries and dependencies.
- Existing operational constraints (SLO/SLA, security, compliance).

## Workflow
1. Map system impact surface (services, data, integrations, dependencies).
2. Identify primary technical constraint.
3. Translate business intent into NFR expectations.
4. Identify top failure modes and risk retirement sequence.
5. Define rollback and backward compatibility guardrails.
6. Return request-scoped artifact with technical notes and source references.

## Output Contract
- Include:
  - primary constraint
  - key dependencies
  - NFR impacts
  - rollback/readiness considerations
- Keep output request-scoped.
- Include `Source References`.
- Include `Readiness Verdict` when readiness is in question.

## Failure/Refinement Behavior
- Return `Needs Refinement` when:
  - dependency map is unclear
  - NFR impacts are missing
  - rollback or compatibility path is not defined for meaningful change
- Include:
  - `Failed Gates`
  - `Missing Sources`


