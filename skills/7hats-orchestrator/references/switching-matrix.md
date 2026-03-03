# Switching Matrix

## Intent Routing (Primary)

| Intent | Primary Hat | Typical Secondary Hats |
| --- | --- | --- |
| `clarify` | `7hats-craft` | `7hats-research`, `7hats-design` |
| `plan` | `7hats-craft` | `7hats-engineer`, `7hats-research` |
| `de-risk` | `7hats-engineer` | `7hats-research`, `7hats-design`, `7hats-entrepreneur` |
| `decide` | `7hats-human` | `7hats-entrepreneur`, `7hats-craft`, `7hats-engineer` |
| `validate` | `7hats-craft` | `7hats-engineer`, `7hats-design` |
| `recover` | `7hats-human` | `7hats-craft`, `7hats-engineer`, `7hats-market` |

## Primary Routing

| Condition | Primary Hat | Typical Secondary Hat |
| --- | --- | --- |
| Ambiguous problem/value | `7hats-researcher` | `7hats-product` |
| Backlog clarity/prioritization | `7hats-product` | `7hats-engineer` |
| UX friction/state failures | `7hats-designer` | `7hats-researcher` |
| Reliability/performance/architecture risk | `7hats-engineer` | `7hats-product` |
| Adoption lag after launch | `7hats-marketer` | `7hats-researcher` |
| Resource trade-offs/portfolio conflict | `7hats-entrepreneur` | `7hats-product` |
| Ownership breakdown/team strain | `7hats-meta` | `7hats-product` |

## Multi-Hat Sequence Patterns

### Mission Creation
1. `7hats-product` (value and scope)
2. `7hats-engineer` (constraints and risks)
3. `7hats-entrepreneur` (bet framing)
4. Optional `7hats-researcher` if evidence is thin

### Signal Creation
1. `7hats-researcher` (signal quality and evidence)
2. `7hats-product` (priority and desired outcome)
3. Optional `7hats-engineer` if technical risk is implied

### Story Breakdown (from Mission/Signal)
1. `7hats-product` (slice strategy)
2. `7hats-engineer` (dependency and risk checks)
3. Optional `7hats-designer` if user-flow complexity is central

## Guardrails
- Do not output multiple artifact types unless explicitly requested.
- If grounding fails, stop and return `Needs Refinement`.
- Keep secondary hat usage additive, not duplicative.
- Intent routes are additive and must preserve canonical/legacy alias compatibility.
