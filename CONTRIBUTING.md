# Contributing

## Contribution Standard

Contributions must preserve:
- Skill trigger clarity
- Request-scoped artifact behavior
- Readiness and grounding requirements

## Pull Request Checklist

- Update affected `SKILL.md` files.
- Update related `references/*` files.
- Keep frontmatter `name` and `description` accurate and explicit.
- Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-skill-bundle.ps1
```

- Update `CHANGELOG.md`.

## Style

- Prefer concise, operational instructions over long prose.
- Avoid duplicate guidance between `SKILL.md` and reference files.
- Keep references practical and decision-oriented.


