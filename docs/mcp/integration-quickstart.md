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
