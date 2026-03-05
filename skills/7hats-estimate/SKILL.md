---
name: 7hats-estimate
description: Estimate agile story points for stories, features, or slice sets using standard estimation strategies. Default to Fibonacci (1,2,3,5,8,13,21) unless the user specifies another strategy or scale.
---

# 7hats Estimate

Use this skill to estimate effort/complexity with standard agile story point approaches.

## Load Order
- `docs/requirements-style.md`
- `docs/definition-of-ready.md`
- `docs/tpm-agent-operating-guide.md`
- Relevant backlog artifacts, stories, and service context docs

## Required Inputs
- Items to estimate (story, feature, or slice set).
- Scope and acceptance criteria per item.
- Dependencies, unknowns, and technical constraints (if known).
- Optional user-specified estimation strategy/scale.

## Workflow
1. Confirm estimation scope and item granularity.
2. Select estimation strategy:
- Use user-specified strategy if provided.
- Default to Fibonacci points: `1, 2, 3, 5, 8, 13, 21`.
3. Apply standard agile heuristics per item:
- effort/complexity
- uncertainty/risk
- dependency load
- testing/validation scope
4. Normalize estimates across the set for relative consistency.
5. Flag outliers and identify assumptions driving larger estimates.
6. Return estimates with confidence notes and risk qualifiers.

## Output Contract
- Keep output request-scoped.
- For each estimated item include:
  - story points
  - estimation strategy/scale used
  - short rationale
  - confidence level
  - key assumptions/risks
- Include `Source References`.
- Include `Readiness Verdict` when source coverage is weak.

## Failure/Refinement Behavior
- Return `Needs Refinement` when:
  - scope/acceptance criteria are too ambiguous to size
  - dependencies or constraints are materially unknown
  - estimation basis is inconsistent across items
- Include:
  - `Failed Gates`
  - `Missing Sources`
  - `Corrective Actions`
