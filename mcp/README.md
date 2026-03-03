# MCP Runtime Scaffold

This folder is the implementation workspace for the 7hats MCP server.

## Contract Source

Implementation must follow:

- `docs/mcp/contract-spec.md`
- `docs/mcp/schemas/*` (as schemas are added)

## Structure

```text
mcp/
  server/
    README.md
    contract-map.json
  tests/
    README.md
    smoke-contract-placeholder.ps1
```

## Scope Boundary

- `docs/mcp/*` defines integration contracts.
- `mcp/*` contains runtime code and tests.
