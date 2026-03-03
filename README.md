# 7 Hats Skill Bundle

Enterprise-ready skill bundle based on *The 7 Hats of Technical Program Managers*.

This package contains simplified command triggers:
- `7hats` (router)
- `7hats-craft`
- `7hats-research`
- `7hats-design`
- `7hats-engineer`
- `7hats-market`
- `7hats-entreprenuer`
- `7hats-human`

## What This Package Is

This repository is a standalone distribution for TPM/Product-owner AI agent workflows.
It includes:
- Skill definitions (`SKILL.md`)
- Agent UI metadata (`agents/openai.yaml`)
- Per-skill operational references
- Shared governance docs for requirements/readiness

## Quick Start

### Option 1: Use In This Repo

Use prompts with explicit skill triggers:
- `$7hats break this Mission into stories...`
- `$7hats-craft create a Story for...`
- `$7hats-engineer assess architecture risks for...`

### Option 2: Install Globally In Codex

PowerShell:

```powershell
$src = "c:\Projects\7hats-skills\skills"
$dst = "$env:USERPROFILE\.codex\skills"
New-Item -ItemType Directory -Force $dst | Out-Null
Copy-Item -Recurse -Force "$src\7hats-*" $dst
```

## Repository Structure

```text
7hats-skills/
  docs/
    the-7-hats-foundation.md
    requirements-style.md
    definition-of-ready.md
    tpm-agent-operating-guide.md
    templates/
      backlog/
      specs/
  skills/
    7hats/
    7hats-craft/
    7hats-research/
    7hats-design/
    7hats-engineer/
    7hats-market/
    7hats-entreprenuer/
    7hats-human/
    # legacy aliases retained
    7hats-orchestrator/
    7hats-product/
    7hats-researcher/
    7hats-designer/
    7hats-marketer/
    7hats-entrepreneur/
    7hats-meta/
  scripts/
    validate-skill-bundle.ps1
```

## Template Source Of Truth

All artifact templates are centralized under `docs/templates`.

- Backlog artifacts:
  - `docs/templates/backlog/mission.md`
  - `docs/templates/backlog/signal.md`
  - `docs/templates/backlog/epic.md`
  - `docs/templates/backlog/user-story.md`
  - `docs/templates/backlog/bug.md`
  - `docs/templates/backlog/feature.md`
  - `docs/templates/backlog/customer-request.md`
- Specs:
  - `docs/templates/specs/design-spec.md`
  - `docs/templates/specs/research-spec.md`

Skill-level `references/templates.md` files point to this shared library so teams can evolve templates in one place.

## Recommended Usage Pattern

- Use `7hats` as the default entrypoint for generic requests.
- Use direct hat skills for explicitly scoped work.
- Keep outputs request-scoped (`Story` vs `Mission` vs `Signal`).

## Quality and Governance

- Readiness and artifact quality rules: `docs/requirements-style.md`, `docs/definition-of-ready.md`
- TPM operating posture: `docs/tpm-agent-operating-guide.md`
- Conceptual framework: `docs/the-7-hats-foundation.md`

## Validation

Run package validation:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-skill-bundle.ps1
```

Run template smoke tests:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\smoke-test-templates.ps1
```

## Versioning

- Semantic versioning is tracked in `VERSION` and `CHANGELOG.md`.


