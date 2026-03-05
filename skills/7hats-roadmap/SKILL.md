---
name: 7hats-roadmap
description: Build roadmap plans from sliced work and interrelated user requests across multiple services and sprints, including milestones, dependencies, and confidence/risk markers.
---

# 7hats Roadmap

Use this skill to build a practical roadmap from slice sets or interrelated backlog requests.

## Load Order
- `docs/requirements-style.md`
- `docs/definition-of-ready.md`
- `docs/tpm-agent-operating-guide.md`
- `docs/operating-system/repo-context-gate.md`
- Relevant architecture/service docs in the target implementation repository

## Workflow
1. Normalize inputs into roadmap units (slices, themes, or story groups).
2. Identify dependency graph and critical path.
3. Cluster work into milestones and sprint/release windows.
4. Assign confidence and risk markers per milestone.
5. Surface tradeoffs and gating decisions for timeline scenarios.
6. Validate roadmap coherence against constraints and readiness gates.

## Output Contract
- Keep output request-scoped.
- Include:
  - roadmap phases or milestones
  - dependency chain highlights
  - risk/confidence markers
  - gating decisions and assumptions
- Include `Source References`.
- Include `Readiness Verdict`.

## Failure/Refinement Behavior
- Return `Needs Refinement` when:
  - dependencies are ungrounded
  - milestone assumptions are missing
  - confidence cannot be justified
- Include:
  - `Failed Gates`
  - `Missing Sources`
  - `Corrective Actions`
