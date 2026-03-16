# Template Library (Source of Truth)

This folder is the default template library for all 7 Hats skills when an attached repo does not provide a more specific template or artifact contract.

## Structure

```text
docs/templates/
  backlog/
    mission.md
    signal.md
    epic.md
    user-story.md
    bug.md
    feature.md
    customer-request.md
  specs/
    design-spec.md
    research-spec.md
  schemas/
    user-story.schema.json
    bug.schema.json
    feature.schema.json
    customer-request.schema.json
    epic.schema.json
    mission.schema.json
    signal.schema.json
    design-spec.schema.json
    research-spec.schema.json
    design-brief.schema.json
```

## Rules
- All skills should inspect the attached repo first for guidance and templates that override bundle defaults.
- If no repo-local override exists, these templates are the bundle fallback source of truth.
- `Mission`, `Signal`, and `User Story` templates are aligned to existing 7 Hats contracts.
- Other templates are defined using common industry patterns and can be extended safely.
- Keep output request-scoped to the requested artifact type.
- Use `schemas/*.schema.json` to validate JSON-shaped artifact payloads.
- DoR enforcement schemas define:
  - `business_context`
  - `technical_context`
  - `validation_context`
  - `execution_governance`
  - `readiness`
