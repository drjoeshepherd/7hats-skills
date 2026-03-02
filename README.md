# 7 Hats Skill Bundle

Enterprise-ready skill bundle based on *The 7 Hats of Technical Program Managers*.

This package contains eight Codex-compatible skills:
- `7hats-orchestrator`
- `7hats-product`
- `7hats-researcher`
- `7hats-designer`
- `7hats-engineer`
- `7hats-marketer`
- `7hats-entrepreneur`
- `7hats-meta`

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
- `$7hats-orchestrator break this Mission into stories...`
- `$7hats-product create a Story for...`
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
  skills/
    7hats-orchestrator/
    7hats-product/
    7hats-researcher/
    7hats-designer/
    7hats-engineer/
    7hats-marketer/
    7hats-entrepreneur/
    7hats-meta/
  scripts/
    validate-skill-bundle.ps1
```

## Recommended Usage Pattern

- Use `7hats-orchestrator` as the default entrypoint for generic requests.
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

## Versioning

- Semantic versioning is tracked in `VERSION` and `CHANGELOG.md`.


