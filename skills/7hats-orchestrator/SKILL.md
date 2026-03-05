---
name: 7hats-orchestrator
description: Legacy alias of 7hats. Intent-first entry for TPM/Product work that routes clarify/plan/de-risk/decide/validate/recover requests to capability skills (7hats-product, analyze-backlog, slice-work, estimate, roadmap) and returns one request-scoped artifact with readiness and source grounding.
---

# 7hats Orchestrator
Use this skill as the user-facing entry point: parse intent, choose internal capabilities, and return only the requested artifact type.

## Load Order
- `references/foundations.md`
- `references/switching-matrix.md`
- `references/core-question-set.md`
- `references/decision-framework.md`
- `references/execution-health-dashboard.md`
- `references/output-contracts.md`
- `docs/operating-system/intent-taxonomy.md`
- `docs/operating-system/capability-catalog.md`
- `docs/operating-system/routing-table.md`
- `docs/operating-system/handoff-contract.md`
- `docs/operating-system/trigger-schema.md`
- `docs/operating-system/repo-context-gate.md`
- `docs/requirements-style.md`
- `docs/definition-of-ready.md`
- `docs/tpm-agent-operating-guide.md`
- Relevant architecture/service docs in the target implementation repository

## When To Use
- User requests outcomes by problem intent (clarify, plan, de-risk, decide, validate, recover).
- Request spans more than one capability (for example backlog analysis plus artifact drafting).
- Request asks for Mission/Signal decomposition or multi-sprint planning.

## When Not To Use
- User explicitly asked for one narrow capability skill and no orchestration.

## Required Inputs
- User request text.
- Requested artifact type (`Story`, `Mission`, `Signal`, or breakdown).
- Available source context (files, links, service docs).

## Workflow
1. Detect repo mode using `docs/operating-system/repo-context-gate.md`:
- Repo-Aware Mode
- Generic Mode
2. Classify artifact type:
- Story-only
- Mission-only
- Signal-only
- Mission/Signal breakdown to stories
3. Classify user intent from `docs/operating-system/intent-taxonomy.md`:
- clarify
- plan
- de-risk
- decide
- validate
- recover
4. Select capability chain from `docs/operating-system/routing-table.md` and `docs/operating-system/capability-catalog.md`.
5. Execute capability steps with internal hat handoffs using `docs/operating-system/handoff-contract.md`.
6. Apply shared question and decision logic:
- Ask the 10 core questions from `references/core-question-set.md`.
- If conflict/uncertainty blocks progress, run `references/decision-framework.md`.
7. Enforce output contract from `references/output-contracts.md`.
8. Validate readiness and grounding:
- If source coverage is insufficient, return `Needs Refinement` with `Missing Sources`.
- Keep output request-scoped (no extra artifact types).

## Output Contract
- Return only requested artifact type(s).
- Include required sections for that type from `references/output-contracts.md`.
- Include `Source References`.
- Include `Readiness Verdict` and required failure fields when applicable.
- Enforce repo mode behavior:
  - Repo-Aware Mode must include concrete repository citations.
  - Generic Mode must avoid repo-specific claims.

## Failure/Refinement Behavior
- Return `Needs Refinement` when:
  - grounding is missing for key claims
  - artifact boundaries are unclear
  - required readiness gates cannot be satisfied
- Include:
  - `Failed Gates`
  - `Missing Sources`
  - `Corrective Actions`

