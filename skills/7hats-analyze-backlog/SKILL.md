---
name: 7hats-analyze-backlog
description: Analyze backlog sets (including CSV exports) to uncover themes, ambiguity, dependency conflicts, risk clusters, and readiness gaps, then recommend next actions for slicing or artifact creation.
---

# 7hats Analyze Backlog

Use this skill to evaluate backlog quality and readiness before planning or drafting artifacts.

## Load Order
- `docs/requirements-style.md`
- `docs/definition-of-ready.md`
- `docs/tpm-agent-operating-guide.md`
- Relevant backlog artifacts, CSV exports, and service/context docs

## Workflow
1. Ingest backlog items and normalize fields (type, area, dependency, status, priority).
2. Group items by theme, workflow stage, and impacted services.
3. Detect ambiguity, readiness gaps, duplicate scope, and dependency conflicts.
4. Identify risk clusters (technical, delivery, adoption, ownership).
5. Recommend corrective actions:
  - clarify
  - split/merge
  - resequence
  - defer
6. Produce summary suitable for follow-on `7hats-slice-work`, `7hats-roadmap`, or `7hats-product`.

## Output Contract
- Keep output request-scoped.
- Include:
  - theme clusters
  - top ambiguities/readiness gaps
  - dependency and risk findings
  - recommended next actions
- Include `Source References`.
- Include `Readiness Verdict`.

## Failure/Refinement Behavior
- Return `Needs Refinement` when:
  - backlog input fields are incomplete for meaningful analysis
  - theme/risk findings cannot be grounded
- Include:
  - `Failed Gates`
  - `Missing Sources`
  - `Corrective Actions`
