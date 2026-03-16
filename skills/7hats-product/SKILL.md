---
name: 7hats-product
description: Generate request-scoped backlog and spec artifacts from intent using repo-aware JSON/markdown templates, falling back to bundle defaults. Use when work must be materialized into Story, Bug, Customer Request, Epic, Feature, Mission, Signal, Design Spec, or Research Spec with readiness and grounding checks.
---

# 7hats Product

Use for template-contract artifact generation, value framing, and request-scoped backlog authoring.

## Load Order
- `references/lens.md`
- `references/diagnostics.md`
- `references/playbooks.md`
- `references/templates.md`
- `docs/templates/README.md`
- `docs/templates/backlog/*.md`
- `docs/templates/specs/*.md`
- `docs/mcp/schemas/create_artifact.request.json`
- `docs/mcp/schemas/create_artifact.response.json`
- `docs/requirements-style.md`
- `docs/definition-of-ready.md`

## When To Use
- User asks to create or rewrite one concrete artifact type.
- Request needs consistent structure across teams/services.
- Generated artifacts must align with repo-local template contracts when available, or bundle template contracts when the repo has no stronger guidance.

## Required Inputs
- Request text and requested artifact type.
- Current constraints/dependencies (if known).
- Available sources for grounding.

## Workflow
1. Clarify business outcome and target behavior change.
2. In Repo-Aware Mode, inspect the attached repo for artifact templates, field conventions, and guidance that may override bundle defaults.
3. Resolve requested artifact type and map to the strongest applicable template contract.
4. Choose prioritization model from `references/lens.md` based on context.
5. Define scope boundaries and smallest viable slice.
6. Generate artifact using repo-local guidance/template contracts first, then `references/templates.md` and `docs/templates/*` as fallback.
7. Run diagnostics from `references/diagnostics.md`.
8. Validate DoR, grounding, and required template fields; return `Needs Refinement` if required fields are missing.

## Output Contract
- Return only requested artifact type.
- Conform to repo-local template field structure when available; otherwise use the bundle fallback field structure for that artifact type.
- Include explicit scope boundaries.
- Include measurable outcomes and testable acceptance criteria.
- Include `Source References` with concrete repo citations.
- Include `Readiness Verdict` when readiness is in question.

## Failure/Refinement Behavior
- Return `Needs Refinement` when:
  - value or outcome is not measurable
  - scope boundaries are missing
  - artifact type requested is not respected
  - source grounding is insufficient
  - required template fields are missing
- Include:
  - `Failed Gates`
  - `Missing Sources`
  - `Corrective Actions`
