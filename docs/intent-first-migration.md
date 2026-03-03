# Intent-First Migration Notes

## What Changed
The recommended usage model is now intent-first through `7hats`, with internal hat orchestration:
- `clarify`
- `plan`
- `de-risk`
- `decide`
- `validate`
- `recover`

## Backward Compatibility
Canonical and legacy hat commands remain supported. Existing hat-explicit prompts still work.

## Recommended Prompt Shift
From:
- `$7hats-engineer assess architecture risks for ...`

To:
- `$7hats de-risk this launch plan ...`

From:
- `$7hats-product create a story ...`

To:
- `$7hats clarify this request into a sprint-ready story ...`

## Repo Context Behavior
When a code repository is attached:
- system uses `Repo-Aware Mode`
- outputs must include concrete repo citations

When no repository is attached:
- system uses `Generic Mode`
- repo-specific claims are avoided
- readiness may be `Needs Refinement` until sources are available

## Migration Checklist
1. Prefer intent-first prompts in team playbooks.
2. Keep artifact requests explicit (`Story`, `Mission`, `Signal`, breakdown).
3. Ensure source references are provided in repo-aware workflows.
4. Adopt MCP v1.1 schemas for intent/repo-mode fields.
