# Cross-Hat Handoff Contract (v2)

## Purpose
Define a standard internal packet for capability-skill execution handoffs across hats.

## Handoff Packet

```json
{
  "capability": "7hats-slice-work",
  "from_hat": "product_owner",
  "to_hat": "engineer",
  "intent": "plan",
  "reason": "cross-service dependency sequencing required",
  "requested_artifact_type": "user_story",
  "context_summary": "one paragraph max",
  "constraints": ["deadline: 2026-04-15", "no schema break"],
  "required_outputs": ["dependency_map", "failure_modes", "rollback_notes"],
  "source_refs": ["services/payments/README.md", "mappings/repo-map.md"]
}
```

## Required Fields
- `capability`
- `from_hat`
- `to_hat`
- `intent`
- `reason`
- `requested_artifact_type`
- `context_summary`
- `required_outputs`

## Optional Fields
- `constraints`
- `source_refs`
- `confidence`
- `deadline`

## Handoff Rules
1. Handoffs are internal orchestration details, not user-facing commands.
2. Each handoff must have a clear reason and expected contribution.
3. Receiving hat must return a receipt summary before final merge.
4. Final user output remains one request-scoped artifact type.

## Receipt Structure
- `handoff_result`: accepted | partial | blocked
- `contribution_summary`: what was added
- `open_risks`: unresolved constraints
- `missing_sources`: if grounding gaps remain

## Failure Behavior
If receiving hat cannot proceed due missing grounding:
1. Return blocked receipt.
2. Include concrete missing references.
3. Propagate `Needs Refinement` if gaps are material.
