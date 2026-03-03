# Output Contracts

## Artifact Separation (Strict)
- Story request -> return Story only.
- Mission request -> return Mission only.
- Signal request -> return Signal only.
- Mission/Signal breakdown request -> return story series only.
- Never merge levels unless explicitly requested.

## Story Contract
Required sections:
- `Title`
- `Scope`
- `Out of Scope`
- `Assumptions`
- `Dependencies`
- `Description`
- `Acceptance Criteria`
- `Estimate`
- `Priority`
- `QA Evidence`
- `Technical Notes`
- `Source References`

Optional:
- `Context/Origin` (only when provided/required)

## Mission Contract
Required sections:
- `Title`
- `Problem Statement` (<=255 chars)
- `Desired Outcome`
- `Success Metrics`
- `Scope Boundary`
- `Primary Hat Lens` (with reason)
- `Bet Framing` (`Hypothesis`, `Minimum Proof`, `Kill Criteria`)
- `Source References`

## Signal Contract
Required sections:
- `Title`
- `Problem Statement` (<=255 chars)
- `Why Now/Urgency`
- `Desired Outcome`
- `Success Metrics`
- `Primary Hat Lens` (with reason)
- `Source References`

## Global Grounding Contract
- Include at least two concrete repo references when possible:
  - one architecture/service reference
  - one mapping/implementation reference
- If source coverage is insufficient, include:
  - `Readiness Verdict: Needs Refinement`
  - `Failed Gates`
  - `Missing Sources`

## Repo Context Gate
- Determine mode at task start:
  - `Repo-Aware Mode` when repository context is available.
  - `Generic Mode` when repository context is unavailable.
- Repo-Aware Mode requirements:
  - Ground implementation claims in repository evidence.
  - Include concrete repository file citations in `Source References`.
  - If required citations are missing, do not mark `Ready`.
- Generic Mode requirements:
  - Avoid repo-specific claims.
  - Mark unknown implementation details as `Unknown - needs discovery`.
  - Return `Needs Refinement` when repo-specific validation is required.

## Internal Scaffolding Rule
- Internal micro-step outputs (risk maps, decision notes, matrices) are allowed during orchestration.
- Final user output must still conform to the single requested artifact contract.

## Readiness Contract
- Use `docs/definition-of-ready.md` as canonical DoR checklist.
- Do not mark `Ready` when business context, technical context, or validation context is incomplete.


