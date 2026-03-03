# Plan: MCP Contract Specification For 7hats

## Objective
Define a stable, implementation-ready MCP contract so 7hats can be consumed by MCP-capable agents without coupling MCP runtime details into skill content files.

## Scope

In scope:
1. Tool catalog and responsibilities.
2. Request/response schema drafts.
3. Auth and tenancy boundaries.
4. Versioning and compatibility rules.
5. Rollout sequence and acceptance tests.

Out of scope:
1. Full MCP server implementation code.
2. Hosting/vendor decisions beyond interface requirements.

## Tool Catalog (v1)

1. `route_hat`
- Purpose: classify request type and dominant constraint, return hat plan.

2. `create_artifact`
- Purpose: generate one request-scoped artifact using canonical template rules.

3. `validate_artifact`
- Purpose: evaluate artifact content against required fields/contracts.

4. `list_templates`
- Purpose: list canonical template names, paths, and versions.

5. `get_template`
- Purpose: return one canonical template definition by name/version.

## Artifact Types (v1)

- `mission`
- `signal`
- `epic`
- `user_story`
- `bug`
- `feature`
- `design_spec`
- `research_spec`
- `customer_request`

## Request/Response Shape (Draft)

### `route_hat` request
- `request_text` (string, required)
- `artifact_type` (enum, optional)
- `context` (object, optional)
- `requested_alias` (string, optional)

### `route_hat` response
- `primary_hat` (enum)
- `secondary_hats` (array enum)
- `constraint_classification` (enum)
- `artifact_type` (enum)
- `rationale` (string)
- `contract_version` (string)

### `create_artifact` request
- `artifact_type` (enum, required)
- `request_text` (string, required)
- `source_references` (array string, optional)
- `output_format` (enum: `markdown` | `json`, required)
- `template_version` (string, optional)
- `alias` (string, optional)

### `create_artifact` response
- `artifact_type` (enum)
- `content_markdown` (string, optional)
- `content_json` (object, optional)
- `readiness_verdict` (enum: `Ready` | `Needs Refinement`)
- `failed_gates` (array string, optional)
- `missing_sources` (array string, optional)
- `template_version` (string)
- `contract_version` (string)

### `validate_artifact` request
- `artifact_type` (enum, required)
- `content` (string|object, required)
- `content_format` (enum: `markdown` | `json`, required)
- `template_version` (string, optional)

### `validate_artifact` response
- `valid` (boolean)
- `score` (number 0-10)
- `missing_required_fields` (array string)
- `violations` (array string)
- `warnings` (array string)
- `contract_version` (string)

### `list_templates` response
- `templates` (array):
  - `name`
  - `artifact_type`
  - `path`
  - `template_version`
  - `status` (`active` | `deprecated`)
- `contract_version` (string)

### `get_template` request
- `name` (string, required)
- `template_version` (string, optional)

### `get_template` response
- `name`
- `artifact_type`
- `template_markdown`
- `template_version`
- `contract_version`

## Auth And Multi-Tenancy

1. API key required for all MCP tool calls.
2. Keys scoped by tenant/org where applicable.
3. Optional per-key capability restrictions:
- `read_templates`
- `create_artifacts`
- `validate_artifacts`
- `route_only`

## Versioning And Compatibility

1. Contract version is explicit on every response.
2. Template version is explicit on template/artifact responses.
3. Breaking changes require MAJOR bump and migration notes.
4. Legacy aliases map at routing layer, not template layer.

## Non-Interference Guardrails

1. Skill files remain the human authoring layer.
2. MCP layer consumes canonical contracts from:
- `docs/templates/*`
- `skills/7hats/references/output-contracts.md`
- `docs/compatibility.md`
3. No MCP-specific behavior should be hardcoded into per-hat content docs.

## Acceptance Tests (Pre-Implementation)

1. Route consistency:
- Same input request -> stable `route_hat` result across runs.

2. Output-scope compliance:
- Story request never returns Mission/Signal sections.
- Mission/Signal requests remain isolated unless explicitly asked for breakdown.

3. Compatibility:
- Canonical and legacy aliases produce equivalent behavior.

4. Validation integrity:
- Missing required fields produce deterministic violations.

## Rollout Sequence

1. Freeze v1 contract in this plan.
2. Add JSON schema files under `docs/mcp/schemas/`.
3. Build MCP server adapter against schema.
4. Add MCP contract smoke tests in CI.
5. Publish integration quickstart for client setup.
