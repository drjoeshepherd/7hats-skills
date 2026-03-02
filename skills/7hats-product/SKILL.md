---
name: 7hats-product
description: Apply Product Owner lens for direct story, mission, or signal authoring: convert intent into measurable backlog value, prioritize work, and produce clear, testable, request-scoped artifacts.
---

# 7hats Product

Use for backlog clarity, value framing, prioritization, and incremental slicing.

## Load Order
- `references/lens.md`
- `references/diagnostics.md`
- `references/playbooks.md`
- `references/templates.md`
- `docs/requirements-style.md`
- `docs/definition-of-ready.md`

## When To Use
- Mission needs sharper value and boundaries.
- Signal needs urgency and outcome clarity.
- Story needs scope cuts and testable AC.
- Backlog priority is disputed or unstable.

## Required Inputs
- Request text and requested artifact type.
- Current constraints/dependencies (if known).
- Available sources for grounding.

## Workflow
1. Clarify business outcome and target behavior change.
2. Choose prioritization model from `references/lens.md` based on context.
3. Define scope boundaries and smallest viable slice.
4. Write artifact using request-scoped template from `references/templates.md`.
5. Run diagnostics from `references/diagnostics.md`.
6. Validate DoR and grounding; return `Needs Refinement` if required fields are missing.

## Output Contract
- Return only requested artifact type.
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
- Include:
  - `Failed Gates`
  - `Missing Sources`


