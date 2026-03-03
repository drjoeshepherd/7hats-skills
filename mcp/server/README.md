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
