---
name: 7hats-product
description: Generate request-scoped backlog and spec artifacts from intent using business-first, repo-aware templates. Use repo-local templates when relevant, but surface implementation detail only when explicitly requested or required by the task.
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
- Initial backlog artifacts should stay business-focused unless implementation detail is explicitly requested.

## Required Inputs
- Request text and requested artifact type.
- Current constraints/dependencies (if known).
- Available sources for grounding.

## Workflow
1. Clarify business outcome and target behavior change.
2. In Repo-Aware Mode, inspect the attached repo for artifact templates, field conventions, and guidance that may override bundle defaults.
3. Resolve requested artifact type and map to the strongest applicable template contract.
4. Choose prioritization model from `references/lens.md` based on context.
5. Set default detail level to business-first for `Mission`, `Signal`, `Epic`, `Feature`, `Story`, `Bug`, and `Customer Request` artifacts.
6. Elevate to implementation detail only when:
- the user explicitly asks for repo-aware or technical content
- the task is `de-risk`, `validate`, or engineering planning
- implementation facts are necessary to avoid a misleading artifact
7. Define scope boundaries and smallest viable slice.
8. Generate artifact using repo-local guidance/template contracts first, then `references/templates.md` and `docs/templates/*` as fallback.
9. Run diagnostics from `references/diagnostics.md`.
10. Validate DoR, grounding, and required template fields; return `Needs Refinement` if required fields are missing.

## Output Contract
- Return only requested artifact type.
- Conform to repo-local template field structure when available; otherwise use the bundle fallback field structure for that artifact type.
- Include explicit scope boundaries.
- Include measurable outcomes and testable acceptance criteria.
- Keep initial backlog artifacts focused on business problem, context, requirements, and acceptance criteria.
- Use `Source References` for the strongest stage-appropriate sources.
- Include concrete repo citations only when implementation detail is explicitly requested or required by the task.
- Include `Readiness Verdict` when readiness is in question.
- Do not add architecture, service, dependency, or rollout detail to early artifacts by default.

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
