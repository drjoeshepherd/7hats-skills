---
name: 7hats-product
description: Generate request-scoped backlog and spec artifacts from intent using canonical JSON/markdown templates. Use when work must be materialized into Story, Bug, Customer Request, Epic, Feature, Mission, Signal, Design Spec, or Research Spec with readiness and grounding checks.
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
- Generated artifacts must align with canonical template contracts.

## Required Inputs
- Request text and requested artifact type.
- Current constraints/dependencies (if known).
- Available sources for grounding.

## Workflow
1. Clarify business outcome and target behavior change.
2. Resolve requested artifact type and map to canonical template.
3. Choose prioritization model from `references/lens.md` based on context.
4. Define scope boundaries and smallest viable slice.
5. Generate artifact using request-scoped template contract from `references/templates.md` and `docs/templates/*`.
6. Run diagnostics from `references/diagnostics.md`.
7. Validate DoR, grounding, and required template fields; return `Needs Refinement` if required fields are missing.

## Output Contract
- Return only requested artifact type.
- Conform to canonical template field structure for that artifact type.
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
