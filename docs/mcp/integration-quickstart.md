# MCP Integration Quickstart (Intent-First v1.1)

## Purpose
Provide a practical integration path for MCP-capable clients using the 7hats intent-first, repo-aware contract.

## Prerequisites
1. Use schemas from `docs/mcp/schemas/*`.
2. Use tool map from `mcp/server/contract-map.json`.
3. Use `mcp/server/adapter.ps1` as local reference behavior.

## Tool Flow
1. `route_hat`: classify intent, repo mode, and hat plan.
2. `create_artifact`: generate request-scoped artifact.
3. `validate_artifact`: run deterministic contract checks.
4. `list_templates` / `get_template`: template discovery and retrieval.

## Contract Migration Notes (v1.0 -> v1.1)
The v1.1 contract adds explainability, collaboration receipt, and structured validation/citation fields.

Additive fields (backward-compatible):
- `route_hat.response`:
  - `reasoning_trace`
  - `request_id`, `trace_id`, `created_at`, `schema_version`, `tool_version`
- `create_artifact.response`:
  - `source_citations`
  - `assumptions`, `open_questions`, `next_best_action`, `score`
  - `reasoning_trace`
  - expanded `orchestration_receipt` with collaboration fields
  - `request_id`, `trace_id`, `created_at`, `schema_version`, `tool_version`
- `validate_artifact.response`:
  - `score_breakdown`
  - `findings`
  - `request_id`, `trace_id`, `created_at`, `schema_version`, `tool_version`

Behavior changes:
1. Canonical hat enums in route/provenance responses:
- `product_owner|researcher|designer|engineer|marketer|entrepreneur|meta`
2. `constraint_classification` now maps to:
- `ambiguity|execution_planning|risk_nfr|option_conflict|quality_gate_check|delivery_drift`
3. In `repo_aware` create requests, `source_references` should be structured citation objects (source + uri), minimum 2.

Consumer upgrade steps:
1. Accept and persist new optional metadata fields.
2. Prefer `findings` over legacy `violations/warnings` strings for automation.
3. Update route-hat enum handling to canonical book hat values.
4. Send structured citations for repo-aware artifact generation.
5. Keep fallback handling for legacy fields during transition window.

## Example: Repo-Aware Route

```json
{
  "request_text": "plan this mission into sprint-ready stories",
  "artifact_type": "mission",
  "intent": "plan",
  "repo_context": {
    "attached": true,
    "mode_hint": "repo_aware",
    "source_refs": [
      "services/pathing/README.md",
      "mappings/repo-map.md"
    ]
  }
}
```

Expected response shape highlights:
- `intent`
- `repo_mode=repo_aware`
- `deterministic_signature`
- `orchestration_receipt`

## Example: Generic Route

```json
{
  "request_text": "clarify this feature request",
  "artifact_type": "user_story",
  "intent": "clarify",
  "repo_context": {
    "attached": false,
    "mode_hint": "generic"
  }
}
```

Expected response shape highlights:
- `repo_mode=generic`
- downstream artifact calls may return `Needs Refinement` if repo grounding is required.

## Example Local Adapter Calls

```powershell
powershell -ExecutionPolicy Bypass -File .\mcp\server\adapter.ps1 -Tool route_hat -RequestPath .\mcp\tests\payloads\route-hat.repo-aware.json
```

```powershell
powershell -ExecutionPolicy Bypass -File .\mcp\server\adapter.ps1 -Tool route_hat -RequestPath .\mcp\tests\payloads\route-hat.generic.json
```

```powershell
powershell -ExecutionPolicy Bypass -File .\mcp\server\adapter.ps1 -Tool validate_artifact -RequestPath .\mcp\tests\payloads\validate-artifact.sample.json
```

## CI Verification
Run:
- `scripts/validate-skill-bundle.ps1`
- `scripts/smoke-test-routing.ps1`
- `scripts/smoke-test-templates.ps1`
- `scripts/smoke-test-intent-routing.ps1`
- `scripts/smoke-test-repo-context.ps1`
- `scripts/smoke-test-mcp-schemas.ps1`
- `mcp/tests/smoke-adapter-dry-run.ps1`

## Pilot Metrics
For pilot measurement, collect MCP responses in JSONL and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\measure-mcp-output-quality.ps1 -InputJsonlPath .\mcp\tests\artifacts\sample-responses.jsonl
```

Metric definitions:
- `docs/operating-system/output-quality-metrics.md`
