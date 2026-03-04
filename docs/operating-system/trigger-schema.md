# Trigger Schema (v1)

## Purpose
Make automated trigger logic deterministic and machine-evaluable.

## Required Trigger Fields

```json
{
  "trigger_id": "de_risk_prelaunch_missing_observability",
  "intent": "de-risk",
  "source": "story.fields.monitoring_plan",
  "predicate": "is_empty",
  "threshold": true,
  "confidence": "high",
  "fallback": "manual_review",
  "on_match": {
    "primary_hat": "engineer",
    "secondary_hats": ["product_owner"],
    "required_outputs": ["technical_notes", "acceptance_criteria_updates"]
  }
}
```

## Field Definitions
- `trigger_id`: stable unique id.
- `intent`: one of `clarify|plan|de-risk|decide|validate|recover`.
- `source`: explicit field/system path.
- `predicate`: deterministic operator.
- `threshold`: expected value/range.
- `confidence`: low|medium|high.
- `fallback`: behavior when source missing/uncertain.
- `on_match`: routing and expected output contributions.

## Allowed Predicates (v1)
- `equals`
- `not_equals`
- `contains`
- `not_contains`
- `is_empty`
- `is_not_empty`
- `gt`
- `gte`
- `lt`
- `lte`
- `in`
- `not_in`

## Evaluation Rules
1. Trigger evaluation must be reproducible for same input.
2. No subjective-only predicates (for example, "seems unclear") without measurable proxy.
3. If required source is unavailable, execute `fallback`.
4. If confidence remains low after fallback, return `Needs Refinement`.

## Fallback Options (v1)
- `manual_review`
- `ask_for_source`
- `default_intent_clarify`
- `needs_refinement`

## Contract Rule
Trigger matches may influence internal orchestration only; they must not violate request-scoped output contracts.
