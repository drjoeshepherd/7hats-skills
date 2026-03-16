# Standards Discovery

Load this file when preparing a review in repo-aware mode.

## Goal
Find the strongest available standards in the attached implementation repository before evaluating code quality.

## Priority Order
1. Review-specific instructions:
- `AGENTS.md`
- coding standards docs
- pairing or code review charters
- repository review policy docs
- contribution guides
2. Engineering quality docs:
- architecture docs
- coding standards
- security guidance
- testing strategy docs
3. Tool-enforced conventions:
- formatter configs
- linter configs
- static analysis configs
- test runner configs
- CI quality gates
4. Local implementation patterns:
- neighboring files in the same module
- existing tests for the affected area
- repeated naming, error handling, or data access conventions

## Common File Patterns
- `AGENTS.md`
- `CONTRIBUTING.md`
- `README.md`
- `*coding-standards*.md`
- `*engineering*.md`
- `*charter*.md`
- `docs/**`
- `.github/workflows/**`
- `.editorconfig`
- `eslint.config.*`, `.eslintrc*`
- `prettier.config.*`, `.prettierrc*`
- `tsconfig*.json`
- `pyproject.toml`, `ruff.toml`, `mypy.ini`
- `package.json`
- `Directory.Build.props`, `.ruleset`, `.editorconfig`
- `go.mod`, `golangci.yml`
- `Cargo.toml`, `clippy.toml`
- test configs such as `vitest.config.*`, `jest.config.*`, `pytest.ini`

## Review Rule
- Prefer explicit standards over inferred standards.
- Prefer tool-enforced standards over stylistic preference.
- If repo-local standards are weak, fall back first to `docs/operating-system/agent-coding-standards.md` and then apply `references/fallback-standards.md` as additive language notes.
- Adapt stack-specific examples to the target language or framework without forcing literal syntax.
- Do not invent a rule when no source supports it.
- If standards are weak, focus findings on correctness, regression risk, safety, and missing validation.
