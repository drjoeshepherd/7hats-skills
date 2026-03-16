# Repo Context Gate (v1)

## Purpose
Ensure 7hats is context-aware of real code repositories and adapts output quality and specificity accordingly.

## Mode Detection
At task start, detect repo context using available signals:
1. Workspace includes `.git`.
2. Repository-like structure exists (services, src, app, architecture, docs).
3. Accessible implementation files and architecture docs are present.

Set mode:
- `Repo-Aware Mode` when repository context is available.
- `Generic Mode` when repository context is not available.

## Repo-Aware Mode Requirements
1. Ground behavior claims in concrete repo evidence.
2. Read relevant repo guidance, templates, docs, and code paths before writing implementation-impact details.
3. Use repo context to avoid contradictions and to tailor output when implementation detail is actually needed.
4. Prefer attached-repo guidance and templates when they exist; treat bundle templates as fallback defaults.
5. Include concrete file citations in `Source References` only when the user asks for implementation detail, or when the task is implementation-oriented (`de-risk`, `validate`, engineering planning, code review).
6. Do not use "same as X" assumptions without validation.

## Output Detail Policy
- Repo-aware mode does not mean every output should expose repo-level detail.
- Default early backlog artifacts to business-first detail even when repo context is available.
- Repo context may be used internally for correctness without being surfaced in the output.
- Surface repo paths, service names, architecture notes, implementation dependencies, and code citations only when:
  - the user explicitly requests repo-aware or implementation detail
  - the current task is `de-risk`, `validate`, engineering planning, or code review
  - implementation facts are required to prevent a misleading artifact
- Design-stage outputs should stay behavior-focused unless technical constraints are explicitly requested.
- Engineering-stage outputs may include repo-specific detail by default because implementation risk is the point of the task.

## Repo Guidance And Template Precedence
When an attached repo is available, every skill must first search for repo-local guidance that can override or refine bundle defaults. Check, when present:
1. `AGENTS.md`, contribution guides, engineering handbooks, ADRs, architecture docs, and review charters.
2. Repo-local artifact templates, backlog conventions, issue forms, PR templates, or docs that define required sections or fields.
3. Tool-enforced conventions and repeated nearby implementation patterns.

Precedence rule:
1. Repo-local guidance and templates override bundle defaults when they are explicit and relevant.
2. Bundle templates remain the fallback baseline when the repo does not define an equivalent requirement.
3. If repo guidance conflicts internally or is incomplete, surface the conflict and return `Needs Refinement` when it blocks a defensible output.

## Generic Mode Requirements
1. Avoid repo-specific implementation claims.
2. Mark unknowns as `Unknown - needs discovery`.
3. If request depends on repo facts, return `Readiness Verdict: Needs Refinement` with missing sources.

## Minimum Citation Rule
When repo-specific detail is required in Repo-Aware Mode, provide at least:
1. One architecture/service reference.
2. One implementation/mapping/code reference.

If repo-specific detail is required and either is missing, do not mark ready.

## Failure Contract
If grounding is insufficient:
- `Readiness Verdict: Needs Refinement`
- `Failed Gates`
- `Missing Sources`

## Non-Negotiable Rules
1. Never present speculative implementation details as facts.
2. Prefer explicit uncertainty over hidden assumptions.
3. Request-scoped output contracts always apply.
4. Repo-awareness only applies to repositories actually accessible in current execution context.

## Validation Expectations
Validation/smoke tests should confirm:
1. Correct mode detection.
2. Repo-aware outputs use repo detail only when the request or task requires it.
3. Implementation-oriented repo-aware outputs contain concrete citations.
4. Generic-mode outputs avoid fabricated repo claims.
