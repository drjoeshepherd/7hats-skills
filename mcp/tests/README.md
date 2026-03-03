# MCP Tests

This folder contains contract-first MCP smoke coverage and adapter dry-run checks.

## Primary Contract

- `docs/mcp/contract-spec.md`

## Test Coverage

1. `smoke-contract-placeholder.ps1`
- Verifies baseline contract docs and tool map presence.

2. `smoke-adapter-dry-run.ps1`
- Executes the local `mcp/server/adapter.ps1` with sample payloads.
- Verifies route determinism (`deterministic_signature`) for same input.
- Verifies repo mode behavior (`repo_aware` vs `generic`).
- Verifies `validate_artifact` deterministic fields.

3. `payloads/*`
- Example request payloads for route and validate scenarios.
