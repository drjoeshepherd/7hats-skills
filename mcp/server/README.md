# MCP Server Stub

This directory will host the MCP server implementation.

## v1 Tool Targets

- `route_hat`
- `create_artifact`
- `validate_artifact`
- `list_templates`
- `get_template`

## Implementation Rules

1. Follow `docs/mcp/contract-spec.md` as the source of truth.
2. Keep skill behavior in `skills/*`; do not copy prompt logic into server code.
3. Return explicit `contract_version` in all responses.
4. Return explicit `template_version` where applicable.

## Reference Adapter

`adapter.ps1` is a local reference adapter that implements contract-shaped responses for:
- `route_hat`
- `create_artifact`
- `validate_artifact`
- `list_templates`
- `get_template`

It is deterministic for the same normalized input and enforces intent/repo-mode fields from v1.1 contract docs.

### Usage

```powershell
powershell -ExecutionPolicy Bypass -File .\mcp\server\adapter.ps1 `
  -Tool route_hat `
  -RequestJson '{"request_text":"plan this mission","artifact_type":"mission"}'
```

```powershell
powershell -ExecutionPolicy Bypass -File .\mcp\server\adapter.ps1 `
  -Tool validate_artifact `
  -RequestPath .\mcp\tests\payloads\validate-artifact.sample.json
```
