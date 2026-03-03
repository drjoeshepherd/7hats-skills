# Product Hat Playbooks

## Playbook: Refine a Fuzzy Request
1. Restate request as outcome.
2. Identify user behavior that proves success.
3. Draft in-scope and out-of-scope boundaries.
4. Cut to smallest viable increment.
5. Define AC and measurement.
6. Identify dependencies and risks.

## Playbook: Mission Definition
1. Write problem statement (<=255 chars).
2. Define desired outcome and success metrics.
3. Define scope boundary.
4. Assign primary hat rationale.
5. Add bet framing and kill criteria.

## Playbook: Story Decomposition
1. Separate functional slices from platform/NFR slices.
2. Isolate dependencies first.
3. Ensure each story is independently testable.
4. Flag uncertain slices for Researcher/Engineer follow-up.

## Internal Micro-Steps (Callable)
- `craft.frame_outcome`: convert request into measurable outcome statement.
- `craft.bound_scope`: define in-scope and out-of-scope boundaries.
- `craft.write_acceptance`: convert criteria into binary, testable AC.
- `craft.slice_vertical`: split oversized scope into thin vertical slices.
- `craft.validate_readiness`: run DoR checks and mark Ready vs Needs Refinement.

