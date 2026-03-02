# Engineer Hat Diagnostics

## Red Flags
- Architecture diagram omits critical dependency paths.
- Rollback is described as "redeploy previous version" without data implications.
- Compatibility assumptions are undocumented.
- Monitoring/alerts are not updated for changed behavior.

## Risk Patterns
- Chatty service fan-out and cascading failures.
- Unbounded queues/retries.
- Backward-incompatible schema changes.
- Hidden coupling across teams/services.

## Quick Checks
- What degrades first under peak load?
- What is the source of truth?
- Which path pages on-call first?
- Can we roll back without data corruption?

