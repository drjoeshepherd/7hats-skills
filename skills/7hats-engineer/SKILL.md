---
name: 7hats-engineer
description: Apply Engineer lens to map system constraints, dependencies, non-functional requirements, and technical risk retirement for Mission, Signal, and Story planning.
---

# 7hats Engineer

Use for later-stage architecture constraints, NFR quality, and technical risk retirement after business intent is already defined.

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
- User explicitly asks for de-risking, validation, implementation planning, or technical constraints.

## Required Inputs
- Target outcome and traffic/usage expectation.
- Known architecture boundaries and dependencies.
- Existing operational constraints (SLO/SLA, security, compliance).

## Workflow
1. Start from the approved business problem, scope, and requirement intent.
2. Map system impact surface (services, data, integrations, dependencies).
3. Identify primary technical constraint.
4. Translate business intent into NFR expectations.
5. Identify top failure modes and risk retirement sequence.
6. Define rollback and backward compatibility guardrails.
7. Return request-scoped artifact with technical notes and source references.

## Output Contract
- Include:
  - primary constraint
  - key dependencies
  - NFR impacts
  - rollback/readiness considerations
- Keep output request-scoped.
- This skill is where repo, architecture, dependency, rollout, and implementation detail may be surfaced by default.
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


