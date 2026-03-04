# Compatibility Guide

This document defines command compatibility, versioning expectations, and deprecation policy for the 7hats skill bundle.

## Canonical Commands

Use these commands for all new usage:

- `7hats` (default router)
- `7hats-craft`
- `7hats-research`
- `7hats-design`
- `7hats-engineer`
- `7hats-market`
- `7hats-entrepreneur`
- `7hats-human`

## Legacy Command Mapping

Legacy names remain available for compatibility:

- `7hats-orchestrator` -> `7hats`
- `7hats-product` -> `7hats-craft`
- `7hats-researcher` -> `7hats-research`
- `7hats-designer` -> `7hats-design`
- `7hats-marketer` -> `7hats-market`
- `7hats-meta` -> `7hats-human`

Notes:
- `7hats-engineer` and `7hats-entrepreneur` are already canonical.
- Deprecated typo alias `7hats-entreprenuer` is removed and must not be used.

## Behavioral Compatibility Contract

All canonical and legacy aliases must preserve the same behavior contract:

1. Request-scoped output only.
2. Artifact boundary enforcement (Story vs Mission vs Signal).
3. Same `default_prompt` intent for alias and mapped target skill.
4. Same template source of truth (`docs/templates/*`).

## Versioning Policy

Semantic versioning applies:

- `MAJOR`: breaking contract changes (field removals/renames, command removals, output contract changes).
- `MINOR`: additive, backward-compatible changes (new templates, optional fields, new checks).
- `PATCH`: fixes and non-breaking clarifications.

### MCP Contract Versioning Notes
1. v1.1 introduces additive explainability and structured validation fields.
2. Clients should treat new fields as optional unless explicitly marked required by schema.
3. During migration, consumers may receive both:
- legacy string issue summaries (`violations`, `warnings`)
- structured findings objects (`findings`)
4. Route-hat canonical response values use short hat names:
- `product_owner`, `researcher`, `designer`, `engineer`, `marketer`, `entrepreneur`, `meta`

## Deprecation Policy

1. Deprecations are announced in `CHANGELOG.md` and release notes.
2. A deprecated command remains supported for at least one major version window.
3. Removal requires:
   - migration mapping
   - replacement command
   - explicit removal version

## Validation Requirements

Before release, all of the following must pass:

- `scripts/validate-skill-bundle.ps1`
- `scripts/smoke-test-templates.ps1`
- `scripts/smoke-test-routing.ps1`
