---
name: 7hats-craft
description: Legacy alias for 7hats-product. Use when users request 7hats-craft; execute the same Product Owner template-driven artifact generation workflow as 7hats-product.
---

# 7hats Craft

Use this as a compatibility alias of `7hats-product`.

## Load Order
- `../7hats-product/references/lens.md`
- `../7hats-product/references/diagnostics.md`
- `../7hats-product/references/playbooks.md`
- `../7hats-product/references/templates.md`
- `docs/templates/README.md`
- `docs/requirements-style.md`
- `docs/definition-of-ready.md`

## Workflow
1. Treat the request as `7hats-product` behavior.
2. In Repo-Aware Mode, inspect the attached repo for guidance and templates that override bundle defaults.
3. Generate request-scoped artifact using repo-local template contracts first and bundle defaults second.
4. Apply readiness and grounding checks.
5. Return output under the same contract as `7hats-product`.

## Output Contract
- Match `7hats-product` output contract exactly.
- Return only the requested artifact type.
- Include `Source References` and `Readiness Verdict`.

## Failure/Refinement Behavior
- Return `Needs Refinement` under the same gate conditions as `7hats-product`.
- Include:
  - `Failed Gates`
  - `Missing Sources`
  - `Corrective Actions`
