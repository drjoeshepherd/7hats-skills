# 7 Hats Skill Bundle

Intent-first TPM skill system for Codex.

Use `7hats` to describe the problem to solve. The system maps intent to internal capability skills and uses hats as internal execution roles.

## Install

### Option 1: Use in this repo
Run prompts directly from this workspace.

### Option 2: Install globally in Codex

```powershell
$src = "c:\Projects\7hats-skills\skills"
$dst = "$env:USERPROFILE\.codex\skills"
New-Item -ItemType Directory -Force $dst | Out-Null
Copy-Item -Recurse -Force "$src\7hats-*" $dst
```

## Commands

### Primary command (recommended)
- `7hats`

### Intent commands (used through `7hats`)
1. `clarify`: turn a fuzzy request into a bounded artifact.
2. `plan`: break work into executable slices and sequencing.
3. `de-risk`: identify and retire technical/delivery risk.
4. `decide`: force explicit tradeoffs and decision criteria.
5. `validate`: run readiness and grounding checks.
6. `recover`: restore momentum when execution drifts.

Example prompts:
- `$7hats clarify this request into a sprint-ready Story`
- `$7hats plan this Feature into sequenced slices and a roadmap`
- `$7hats de-risk this launch plan`
- `$7hats decide between option A and B for onboarding`
- `$7hats validate this Story before sprint commitment`
- `$7hats recover this initiative; decisions are stalled`
- `$7hats-code-review review this diff and return JSON findings`

### Capability skills (advanced/direct)
- `7hats-product`
- `7hats-analyze-backlog`
- `7hats-slice-work`
- `7hats-roadmap`
- `7hats-estimate`
- `7hats-code-review`

### Hat skills (internal role lenses; advanced/direct)
- `7hats-product` (Product Owner lens)
- `7hats-research`
- `7hats-design`
- `7hats-engineer`
- `7hats-market`
- `7hats-entrepreneur`
- `7hats-human`

## Output Contract

Outputs are always request-scoped:
- Story request -> Story only
- Mission request -> Mission only
- Signal request -> Signal only
- Mission/Signal breakdown -> story series only

## Repo Context Behavior

The system auto-detects execution context:
- `Repo-Aware Mode`: when a real code repo is attached; responses must cite real files and align to actual architecture/code.
- `Generic Mode`: when no repo is attached; speculative implementation details are avoided and readiness may be `Needs Refinement`.
- `7hats-code-review` first scans the attached repo for standards in Repo-Aware Mode and falls back to this bundle's baseline review standards when none are found.

## MCP

MCP contract and schemas:
- `docs/mcp/contract-spec.md`
- `docs/mcp/schemas/*`

Integration quickstart:
- `docs/mcp/integration-quickstart.md`

Reference adapter:
- `mcp/server/adapter.ps1`

Adapter example:

```powershell
powershell -ExecutionPolicy Bypass -File .\mcp\server\adapter.ps1 `
  -Tool route_hat `
  -RequestPath .\mcp\tests\payloads\route-hat.repo-aware.json
```

## Validate

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-skill-bundle.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\smoke-test-templates.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\smoke-test-routing.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\smoke-test-intent-routing.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\smoke-test-repo-context.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\smoke-test-mcp-schemas.ps1
powershell -ExecutionPolicy Bypass -File .\mcp\tests\smoke-contract-placeholder.ps1
powershell -ExecutionPolicy Bypass -File .\mcp\tests\smoke-adapter-dry-run.ps1
```

## Key Docs

- `docs/requirements-style.md`
- `docs/definition-of-ready.md`
- `docs/the-7-hats-foundation.md`
- `docs/compatibility.md`
- `docs/intent-first-migration.md`
- `docs/operating-system/capability-catalog.md`
- `VERSION` and `CHANGELOG.md` for releases


Note: 7hats-craft remains supported as a legacy alias of 7hats-product.
