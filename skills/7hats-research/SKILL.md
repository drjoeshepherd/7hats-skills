---
name: 7hats-research
description: Apply Researcher lens for data-driven signal work and uncertainty reduction: convert assumptions, analytics trends, and drop-off patterns into testable hypotheses, evidence plans, and decision thresholds.
---

# 7hats Research

Use for unknowns, assumptions, and evidence-driven decision making.

## Load Order
- `references/lens.md`
- `references/diagnostics.md`
- `references/playbooks.md`
- `references/templates.md`
- `docs/requirements-style.md`

## When To Use
- Request has unresolved assumptions.
- Team debates opinions without evidence.
- Mission or Signal requires validation before commitment.

## Required Inputs
- Target decision to be informed.
- Key assumptions and unknowns.
- Existing data sources/telemetry (if available).

## Workflow
1. Define the decision that evidence must support.
2. Convert assumptions into a hypothesis using template.
3. Choose method (interview, usability, logs, A/B, survey) from `references/lens.md`.
4. Define threshold that confirms or rejects hypothesis.
5. Map experiment output to backlog action.
6. Emit request-scoped artifact and include evidence caveats.

## Output Contract
- Include hypothesis, method, threshold, and decision trigger.
- Keep artifact type request-scoped.
- Include `Source References` and confidence level.
- Include `Readiness Verdict` when readiness is in question.

## Failure/Refinement Behavior
- Return `Needs Refinement` when:
  - hypothesis is missing or not testable
  - evidence threshold is undefined
  - decision trigger/review point is missing
- Include:
  - `Failed Gates`
  - `Missing Sources`


