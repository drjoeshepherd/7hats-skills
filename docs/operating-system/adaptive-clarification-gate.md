# Adaptive Clarification Gate (v1)

## Purpose
Define when 7hats should ask follow-up questions versus proceeding with best-effort output and explicit readiness gating.

## Policy
Ask clarifying questions only when at least one trigger is true:
1. `routing_confidence = low`
2. Grounding is insufficient for required claims
3. Artifact type ambiguity would change output contract

Otherwise, proceed without clarification and return a bounded output.

## Question Limits
1. Ask 1-3 questions maximum.
2. Questions must be short, decision-driving, and non-overlapping.
3. If still unresolved after max questions, continue with:
- `Readiness Verdict: Needs Refinement`
- explicit `Failed Gates`
- explicit `Missing Sources`
- `next_best_action`

## Trigger To Question Mapping
1. Low confidence route:
- Ask for dominant intent (`clarify|plan|de-risk|decide|validate|recover`).

2. Missing grounding:
- Ask for concrete source references (docs, service path, code path, mapping).

3. Artifact ambiguity:
- Ask user to select one artifact type (`signal|mission|story-level type`).

## Guardrails
1. Clarification must not break request-scoped output contracts.
2. Do not ask for information already present in `repo_context` or source references.
3. Do not ask generic discovery questions when deterministic checks can fail fast.

## Output Requirements After Clarification
Responses should include:
- resolved assumptions
- remaining open questions
- reasoning trace summary
- readiness verdict and gates

