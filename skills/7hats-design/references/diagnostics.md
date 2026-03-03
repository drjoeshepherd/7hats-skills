# Designer Hat Diagnostics

## Red Flags
- Story has no behavior-level UX expectation.
- "Happy path only" acceptance criteria.
- Accessibility treated as post-build cleanup.
- Recovery behavior unspecified for error conditions.

## Anti-Patterns
- Pretty-but-brittle designs.
- State ambiguity hidden in handoff.
- Interface choices without user-behavior rationale.

## Quick Checks
- What happens under degraded network/system conditions?
- Can user recover from failure without support?
- How is success measured in user behavior terms?

