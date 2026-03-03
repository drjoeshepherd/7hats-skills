# Engineer Hat Playbooks

## Playbook: Mission Technical Readiness
1. Identify affected services and data stores.
2. Define primary technical constraint.
3. Document NFR targets and observability changes.
4. List top 3 failure modes and mitigation steps.
5. Define rollback strategy and ownership.

## Playbook: Signal Technical Triage
1. Determine if signal implies architecture risk or ops debt.
2. Estimate blast radius by service boundary.
3. Recommend immediate guardrail action.
4. Recommend deeper discovery if uncertainty remains high.

## Playbook: Story Risk Retirement
1. Add technical notes for API/data/infra impacts.
2. Validate compatibility and migration assumptions.
3. Define minimum pre-release checks.

## Internal Micro-Steps (Callable)
- `engineer.model_constraints`: document key NFR and operating constraints.
- `engineer.map_failures`: list top failure modes, impact, and recovery paths.
- `engineer.map_system`: map dependencies, boundaries, and blast radius.
- `engineer.define_eng_done`: add survivability and operability completion checks.
- `engineer.align_observability`: define required signals, metrics, and alert posture.

