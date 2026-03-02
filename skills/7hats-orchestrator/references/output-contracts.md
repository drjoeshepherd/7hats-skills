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

## Readiness Contract
- Use `docs/definition-of-ready.md` as canonical DoR checklist.
- Do not mark `Ready` when business context, technical context, or validation context is incomplete.


