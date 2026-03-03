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

## 1.0.0 - 2026-03-02

- Initial standalone release of 7 Hats skill bundle.
- Included 8 skills (`7hats-orchestrator` + 7 hat-specific skills).
- Added per-skill operational references (`lens`, `diagnostics`, `playbooks`, `templates`).
- Added shared orchestrator references (switching matrix, output contracts, decision framework, core question set, execution dashboard).
- Added package-level docs and validation script.
