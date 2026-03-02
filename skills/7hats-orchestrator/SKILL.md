---
name: 7hats-orchestrator
description: Route TPM/Product Owner work when hat selection is unclear or multi-domain, select single or multi-hat sequence, and produce request-scoped Mission, Signal, Story, or Mission/Signal story-breakdown outputs with grounded sources and readiness gates.
---

# 7hats Orchestrator

Use this skill to classify request type and dominant constraint, select the right hat sequence, and return only the requested artifact type.

## Load Order
- `references/foundations.md`
- `references/switching-matrix.md`
- `references/core-question-set.md`
- `references/decision-framework.md`
- `references/execution-health-dashboard.md`
- `references/output-contracts.md`
- `docs/requirements-style.md`
- `docs/definition-of-ready.md`
- `docs/tpm-agent-operating-guide.md`
- Relevant architecture/service docs in the target implementation repository

## When To Use
- Request needs automatic hat selection.
- Request spans more than one constraint (for example ambiguity plus architecture risk).
- Request asks for Mission/Signal decomposition into a story series.

## When Not To Use
- User explicitly asked for one hat and one narrow output (use that specific `7hats-*` skill).

## Required Inputs
- User request text.
- Requested artifact type (`Story`, `Mission`, `Signal`, or breakdown).
- Available source context (files, links, service docs).

## Workflow
1. Classify artifact type:
- Story-only
- Mission-only
- Signal-only
- Mission/Signal breakdown to stories
2. Classify dominant constraint:
- Ambiguity/high unknowns
- Backlog clarity/prioritization
- UX friction/state design
- System/NFR risk
- Adoption/enablement risk
- Portfolio allocation/bet risk
- Team-system/decision-health risk
3. Select hat strategy using `references/switching-matrix.md`.
4. Apply shared question and decision logic:
- Ask the 10 core questions from `references/core-question-set.md`.
- If conflict/uncertainty blocks progress, run `references/decision-framework.md`.
5. Enforce output contract from `references/output-contracts.md`.
6. Validate readiness and grounding:
- If source coverage is insufficient, return `Needs Refinement` with `Missing Sources`.
- Keep output request-scoped (no extra artifact types).

## Output Contract
- Return only requested artifact type(s).
- Include required sections for that type from `references/output-contracts.md`.
- Include `Source References`.
- Include `Readiness Verdict` and required failure fields when applicable.

## Failure/Refinement Behavior
- Return `Needs Refinement` when:
  - grounding is missing for key claims
  - artifact boundaries are unclear
  - required readiness gates cannot be satisfied
- Include:
  - `Failed Gates`
  - `Missing Sources`
  - `Corrective Actions`



