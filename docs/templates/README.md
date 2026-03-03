# Template Library (Source of Truth)

This folder is the canonical template library for all 7 Hats skills.

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
    design-brief.schema.json
```

## Rules
- All skills should use these templates as the source of truth.
- `Mission`, `Signal`, and `User Story` templates are aligned to existing 7 Hats contracts.
- Other templates are defined using common industry patterns and can be extended safely.
- Keep output request-scoped to the requested artifact type.
- Use `schemas/design-brief.schema.json` to validate JSON-shaped design brief payloads.
