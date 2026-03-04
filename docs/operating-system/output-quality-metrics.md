# Output Quality Metrics (Pilot v1)

## Purpose
Define measurable indicators for output quality and explainability upgrades.

## Metrics
1. Quality envelope coverage
- Definition: percent of `create_artifact` responses containing:
  - `readiness_verdict`
  - `score`
  - `failed_gates` (when not ready)
  - `missing_sources` (when grounding is insufficient)
  - `assumptions`
  - `open_questions`
  - `next_best_action`
- Target: 100%

2. Repo-aware structured citation coverage
- Definition: percent of repo-aware `create_artifact` responses with `source_citations` count >= 2.
- Target: 100%

3. Mixed-artifact violation rate
- Definition: percent of validations where request-scoped artifact contract is violated.
- Target: 0%

4. Adaptive clarification precision
- Definition: percent of low-confidence routes that produce clarification prompts (max 3).
- Target: >= 90%

5. Reasoning trace coverage
- Definition: percent of routed/orchestrated responses containing `reasoning_trace`.
- Target: 100%

6. Collaboration receipt coverage
- Definition: percent of `create_artifact` responses containing:
  - `orchestration_receipt.required_outputs`
  - `orchestration_receipt.contribution_summary`
  - `orchestration_receipt.unresolved_risks`
  - `orchestration_receipt.receipt`
- Target: 100%

## Collection Guidance
1. Capture MCP responses into JSONL files during pilot.
2. Compute daily and weekly rollups by tool.
3. Track readiness distributions (`Ready` vs `Needs Refinement`) and top failed gates.

## Reporting Cadence
1. Daily operational snapshot (engineering/TPM).
2. Weekly trend review with action items.
3. End-of-pilot decision against kill criteria.

