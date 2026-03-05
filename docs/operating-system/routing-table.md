# Intent To Capability Routing Table (v2)

## Purpose
Map public intents to internal capability skills while preserving request-scoped output contracts.

## Routing Table

| Intent | Primary Capability | Supporting Capabilities | Typical Internal Steps |
| --- | --- | --- | --- |
| `clarify` | `7hats-product` | `7hats-analyze-backlog`, `7hats-slice-work` | Outcome framing, ambiguity removal, artifact hardening |
| `plan` | `7hats-slice-work` | `7hats-estimate`, `7hats-roadmap`, `7hats-product` | Vertical slicing, estimation, dependency sequencing, sprint/release plan |
| `de-risk` | `7hats-analyze-backlog` | `7hats-slice-work`, `7hats-product` | Risk clustering, readiness gaps, mitigation stories |
| `decide` | `7hats-product` | `7hats-analyze-backlog` | Tradeoff framing, option criteria, decision-ready artifact |
| `validate` | `7hats-analyze-backlog` | `7hats-product` | DoR checks, grounding checks, template contract checks |
| `recover` | `7hats-roadmap` | `7hats-analyze-backlog`, `7hats-product` | Drift diagnostics, resequencing, corrective plan |

## Selection Rules
1. Use explicit user intent if provided.
2. If multiple intents are present, choose primary by first explicit intent and treat others as secondary goals.
3. If no explicit intent, infer from dominant constraint:
- ambiguity -> `clarify`
- execution planning -> `plan`
- risk/NFR concern -> `de-risk`
- option conflict -> `decide`
- quality gate check -> `validate`
- delivery drift -> `recover`
4. If workload includes CSV backlog or batch request sets, prefer `7hats-analyze-backlog` before `7hats-product`.
5. If workload spans multiple services and sprints, include `7hats-slice-work` and `7hats-roadmap`.

## Artifact Preservation Rules
1. Requested artifact type always wins.
2. Internal capability chaining must not produce extra artifact levels.
3. For Mission/Signal breakdown requests, return story series only.

## Escalation Rules
1. If routing confidence < medium, add `Assumptions` and recommend quick clarification.
2. If required repo evidence is unavailable, return `Needs Refinement`.

## Internal Execution Note
Hats are execution roles used inside capability skills (for example engineer/designer/research handoffs). Hats are not the public entry interface.

## Compatibility
This table is additive and does not remove canonical skill commands or legacy aliases.


