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
- Verifies enum-safe route fields (`primary_hat`, `constraint_classification`).
- Verifies explainability and trace fields (`reasoning_trace`, `trace_id`).
- Verifies structured create-artifact outputs (`source_citations`, `next_best_action`).
- Verifies collaboration receipt fields (`required_outputs`, `contribution_summary`, `unresolved_risks`, `receipt`).
- Verifies strict repo-aware citation gating (legacy string refs return `Needs Refinement`).
- Verifies structured validate-artifact outputs (`findings`, `score_breakdown`).
- Verifies artifact materialization validation (`artifact_completeness`, `MISSING_ARTIFACT_OUTPUT`).

3. `payloads/*`
- Example request payloads for route, create, and validate scenarios, including structured source citations.
