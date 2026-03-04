# Changelog

## 1.1.0 - 2026-03-03

- Added intent-first operating-system specs under `docs/operating-system/*` (taxonomy, routing, handoff, trigger schema, repo-context gate).
- Implemented Phase 2 router and playbook integration for intent parsing, repo-mode enforcement, and internal callable micro-steps.
- Added Phase 3 validation/smoke coverage:
  - `scripts/smoke-test-intent-routing.ps1`
  - `scripts/smoke-test-repo-context.ps1`
  - extended `scripts/validate-skill-bundle.ps1` checks
- Implemented Phase 4 MCP contract/schema upgrades:
  - intent/repo-aware routing fields
  - deterministic route/validate fields
  - full schema set for `validate_artifact`, `list_templates`, `get_template`
- Added MCP reference adapter at `mcp/server/adapter.ps1` with dry-run smoke test:
  - `mcp/tests/smoke-adapter-dry-run.ps1`
  - payload samples under `mcp/tests/payloads/*`
- Added integration and migration documentation:
  - `docs/mcp/integration-quickstart.md`
  - `docs/intent-first-migration.md`
- Expanded CI workflow to run full smoke suite, including intent-routing, repo-context, MCP schema, and adapter dry-run tests.
- Added output-quality and explainability execution artifacts:
  - `.plans/output-quality-explainability-upgrade-plan.md`
  - `docs/operating-system/adaptive-clarification-gate.md`
- Upgraded MCP schemas for additive v1.1 compatibility improvements:
  - hat/constraint enums in `route_hat.response`
  - optional `reasoning_trace` in `route_hat.response` and `create_artifact.response`
  - structured `findings` and `score_breakdown` in `validate_artifact.response`
  - structured citation support in `route_hat.request`, `create_artifact.request`, and `create_artifact.response`
  - optional tracing/version metadata fields (`request_id`, `trace_id`, `created_at`, `schema_version`, `tool_version`)
- Extended MCP adapter and smoke coverage to execute v1.1 contracts:
  - adapter now emits canonical book hat values (`product_owner|researcher|designer|engineer|marketer|entrepreneur|meta`)
  - adapter now maps `constraint_classification` to contract enum values
  - adapter now emits reasoning trace, source citations, quality-envelope fields, and structured validation findings
  - added payload fixtures:
    - `mcp/tests/payloads/route-hat.repo-aware.structured.json`
    - `mcp/tests/payloads/create-artifact.repo-aware.structured.json`
  - expanded tests:
    - `mcp/tests/smoke-adapter-dry-run.ps1`
    - `scripts/smoke-test-mcp-schemas.ps1`
- Completed remaining output-quality plan items:
  - enforced repo-aware citation policy for create-artifact (structured citation objects, minimum 2)
  - expanded collaboration receipt contract (`required_outputs`, `contribution_summary`, `unresolved_risks`, `receipt`)
  - added migration guidance to `docs/mcp/integration-quickstart.md` and versioning notes to `docs/compatibility.md`
  - added metrics instrumentation docs and script:
    - `docs/operating-system/output-quality-metrics.md`
    - `scripts/measure-mcp-output-quality.ps1`

## 1.0.0 - 2026-03-02

- Initial standalone release of 7 Hats skill bundle.
- Included 8 skills (`7hats-orchestrator` + 7 hat-specific skills).
- Added per-skill operational references (`lens`, `diagnostics`, `playbooks`, `templates`).
- Added shared orchestrator references (switching matrix, output contracts, decision framework, core question set, execution dashboard).
- Added package-level docs and validation script.
