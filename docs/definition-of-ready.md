# Career Highways - Definition of Ready

## PO Agent Context File (Backlog Refinement Standard)

### Core Principle

No work enters execution without bounded clarity.

A work item is "Ready" only when its **Business Context (Why)**, **Technical Context (How)**, and **Validation Context (How we know)** are sufficiently defined to prevent late discovery, scope drift, and avoidable rework.

Scope is defined as:

> A bounded description of why the work exists, how it will be executed, and how completion will be objectively verified.

If any of these three boundaries are unclear, the item is not Ready.

## 1. Readiness Model

### 1.1 Business Context (Why)

Owned by: Product (PO / CPO)

Must define:
- Clear business purpose or value
- Business outcome
- Business risk awareness
- Stakeholder impact
- Business dependencies
- Constraints
- Priority

The agent must ensure:
- The problem being solved is explicit.
- The value is concrete (user, system, compliance, infrastructure, etc.).
- Out-of-scope boundaries are stated.
- Assumptions affecting scope are stated.
- Acceptance criteria are defined or clearly referenced.

If business value cannot be articulated clearly, the item is not Ready.

### 1.2 Technical Context (How)

Owned by: Engineering (Dev Team, led by Technical Lead)

Must define:
- Clear technical scope
- Feasibility understanding
- Known dependencies
- Technical risks surfaced
- Estimate assigned
- Appropriately sized for sprint

The agent must ensure:
- Technical implications are understood before commitment.
- Dependencies are visible.
- Risks (complexity, debt, unknowns) are acknowledged.
- The item is not oversized (XXL indicates mandatory breakdown).

If engineering cannot estimate or articulate feasibility, the item is not Ready.

### 1.3 Validation Context (How We Know)

Shared responsibility: Product + Engineering

Must define:
- Clear acceptance criteria
- Binary pass/fail conditions
- Observable outcomes
- QA validation path

The agent must ensure:
- Every acceptance criterion is:
  - Testable
  - Independent
  - Binary
- Criteria focus on behavior, not implementation detail (unless technical task).
- 3-7 criteria preferred. More indicates oversizing.
- Work not covered by acceptance criteria is out of scope unless explicitly stated.

If completion cannot be objectively verified, the item is not Ready.

## 2. Required Work Item Structure

A work item must contain the following minimum properties to be considered Ready.

### 2.1 Title (Required)

Format:

`[System Area] Clear Summary`

System Area examples: Journey, Central, Certifications API, Jobs API, etc.

Title type conventions:

Feature (Story):
`As a <Role>, I want <Goal>`

Bug:
`<System Component> <Unwanted Behavior> (<Condition> optional)`

Task:
`Direct instruction describing work`

Title must reflect system context and intent clearly.

### 2.2 Description / Summary (Required)

Must clearly define relevant context(s):
- Feature -> primarily Business Context
- Technical Task -> primarily Technical Context
- Bug -> Business impact + Reproduction Steps

Description must:
- Be concise but unambiguous.
- Explicitly define scope boundaries.
- Include:
  - Scope
  - Out of Scope
  - Assumptions (if material)
  - Dependencies (if known)
- Avoid embedding detailed technical design unless warranted.
- Avoid verbose AI-generated content.
- Include reproduction steps for bugs (if no separate field).
- Reference supporting documents when necessary instead of overloading description.

If scope boundaries are not clear from the description, the item is not Ready.

### 2.3 Acceptance Criteria (Required)

May exist as separate field or clearly formatted in Description.

Format preference:

Given <context>
When <action>
Then <expected outcome>

Rules:
- One behavior per line.
- Binary (pass/fail).
- Observable outcome.
- No unnecessary implementation guesses.
- Prefer 3-7 criteria.
- Criteria define the done state.
- Anything not covered is out of scope.

### 2.4 Story Point Estimate (Required)

Must represent combined:
- Complexity
- Effort
- Risk (business + technical + validation)

Scale:
- XS = 1
- S = 2-3
- M = 5
- L = 8
- XL = 13
- XXL = 21+ (must be broken down)

If estimate cannot be agreed upon jointly by Product and Engineering, item is not Ready.

### 2.5 Priority (Required for Top-Level Items)

Integer scale:
- 1 - Urgent
- 2 - High
- 3 - Medium (default sprint work)
- 4 - Low (de-scope candidate)

Child items inherit parent priority unless explicitly overridden for sequencing.

Priority reflects business value, not effort.

### 2.6 QA Evidence Field (Required)

Must document validation results against defined scope.

Prefer:
- Concise summary
- Links to supporting documentation
- Clear traceability to acceptance criteria

Required for SOC 2 Type 2 compliance.

### 2.7 Field Lifecycle (When Fields Must Be Present)

Required before marking `Ready`:
- Title
- Description / Summary (including scope boundaries and out-of-scope)
- Acceptance Criteria
- Estimate
- Priority (top-level items)
- Technical context, dependencies, and risks
- QA Evidence placeholder (field exists, can be marked `TBD`)

Required before marking item complete/closed:
- QA Evidence populated with validation summary and links
- Traceability from QA evidence to acceptance criteria

## 3. Obsolete Fields (Item-Level)

The following should not be used as separate backlog item fields:
- `Implementation Plan` (fold into description or technical notes)
- `Definition of Done` (defined at project/workflow level, not item level)
- Separate `Scope` field (scope must live in Description)

## 4. Planning Friction Awareness (Priority x Effort)

Planning Friction Score (PFS) = Priority x Effort

Used for sprint discipline.

Interpretation:
- 1-6: Immediate Leverage
- 7-15: Core Sprint Work
- 16-25: Planned Investment (limit quantity)
- 26-40: Capacity Risk (justify explicitly, limit to one)
- 41-52: Strategic Theme (sprint-level commitment)

The agent should flag:
- Low-priority / high-effort work.
- XXL items not broken down.
- Sprints overloaded with 16+ PFS items.
- Large items without explicit strategic justification.

## 5. Comment Discipline (Documentation Integrity)

Comments are official, traceable documentation.

Must:
- Be concise.
- Summarize decisions.
- Reflect field changes.
- Capture decisions made outside the system.
- Tag relevant stakeholders.
- Clarify blockers.
- Avoid low-value updates ("Working on it").

Comments must not replace required DoR fields.

## 6. DoR Gate - Readiness Checklist

Before marking Ready, confirm:
- Business value is explicit.
- Scope boundaries are defined.
- Out-of-scope is stated.
- Dependencies are visible.
- Risks surfaced.
- Acceptance criteria are binary and testable.
- Estimate agreed upon.
- Priority assigned (if top-level).
- Item appropriately sized.
- Completion can be objectively verified.

If any condition fails, return item for refinement.

## 7. Operating Intention

The Definition of Ready exists to:
- Prevent scope instability.
- Reduce late discovery.
- Protect velocity predictability.
- Improve throughput reliability.
- Reduce developer frustration.
- Increase delivery quality.

The agent's role during backlog refinement is to enforce clarity at system entry.

No bounded clarity -> No sprint commitment.

