# Intent To Hat Routing Table (v1)

## Purpose
Map public intents to internal hat orchestration while preserving request-scoped output contracts.

## Routing Table

| Intent | Primary Hat | Secondary Hats | Typical Internal Steps |
| --- | --- | --- | --- |
| `clarify` | Product Owner (`product_owner`) | Researcher, Designer | Outcome framing, scope boundaries, AC hardening |
| `plan` | Product Owner (`product_owner`) | Engineer, Researcher | Vertical slicing, dependency sequencing, estimability checks |
| `de-risk` | Engineer | Researcher, Designer, Entrepreneur | Constraint mapping, failure modes, evidence gates, rollback guards |
| `decide` | Meta (`meta`) | Entrepreneur, Product Owner, Engineer | Tradeoff framing, decision trigger, owner/date receipt |
| `validate` | Product Owner (`product_owner`) | Engineer, Designer | DoR checks, source grounding checks, AC testability checks |
| `recover` | Meta (`meta`) | Product Owner, Engineer, Marketer | Drift diagnostics, transition enforcement, corrective sequence |

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

## Artifact Preservation Rules
1. Requested artifact type always wins.
2. Internal hat changes must not produce extra artifact levels.
3. For Mission/Signal breakdown requests, return story series only.

## Escalation Rules
1. If routing confidence < medium, add `Assumptions` and recommend quick clarification.
2. If required repo evidence is unavailable, return `Needs Refinement`.

## Compatibility
This table is additive and does not remove canonical skill commands or legacy aliases.
