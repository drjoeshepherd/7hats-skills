$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$templatesRoot = Join-Path $root "docs\templates"
$designBriefSchemaPath = Join-Path $templatesRoot "schemas\design-brief.schema.json"
$dorSchemaPaths = @(
  "schemas\\user-story.schema.json",
  "schemas\\bug.schema.json",
  "schemas\\feature.schema.json",
  "schemas\\customer-request.schema.json",
  "schemas\\epic.schema.json",
  "schemas\\mission.schema.json",
  "schemas\\signal.schema.json",
  "schemas\\design-spec.schema.json",
  "schemas\\research-spec.schema.json"
)

if (-not (Test-Path $templatesRoot)) {
  throw "Missing templates directory: $templatesRoot"
}

$checks = @(
  @{
    Name = "Mission"
    Path = "backlog\mission.md"
    Required = @("Problem Statement", "Desired Outcome", "Success Metrics", "Scope Boundary", "Bet Framing", "Source References")
  },
  @{
    Name = "Signal"
    Path = "backlog\signal.md"
    Required = @("Problem Statement", "Why Now/Urgency", "Desired Outcome", "Success Metrics", "Source References")
  },
  @{
    Name = "Epic"
    Path = "backlog\epic.md"
     Required = @("Title", "Description", "Context", "Acceptance Criteria", "Readiness Verdict", "Source References", "In Scope", "Out of Scope", "Success Metrics", "Dependencies", "Risks", "Milestones / Story Breakdown Strategy", "Failed Gates", "Missing Sources")
  },
  @{
    Name = "User Story"
    Path = "backlog\user-story.md"
    Required = @("Title", "Scope", "Out of Scope", "Acceptance Criteria", "Estimate", "Priority", "Source References")
  },
  @{
    Name = "Bug"
    Path = "backlog\bug.md"
    Required = @("Severity", "Steps To Reproduce", "Expected Result", "Actual Result", "User/Business Impact")
  },
  @{
    Name = "Feature"
    Path = "backlog\feature.md"
    Required = @("Problem Statement", "User/Business Value", "Scope", "Acceptance Criteria", "Success Metrics")
  },
  @{
    Name = "Design Spec"
    Path = "specs\design-spec.md"
    Required = @(
      "## 1. Overview",
      "Title:",
      "Requestor:",
      "Priority:",
      "Target Release:",
      "## 2. Problem Definition",
      "Background / Context:",
      "Problem Statement:",
      "## 3. Desired Outcome",
      "Goal:",
      "User Impact:",
      "Business Impact:",
      "## 4. Scope",
      "In Scope:",
      "Out of Scope:",
      "## 5. Experience Definition",
      "Primary Flow:",
      "Edge Cases (if applicable):",
      "## 6. Dependencies",
      "Related features / technical dependencies / blocking items",
      "## 7. Success Criteria",
      "How will we measure improvement?",
      "## 8. Design Deliverables (Completed by Design)",
      "Figma link",
      "Components updated",
      "Tokens impacted",
      "Prototype annotations"
    )
  },
  @{
    Name = "Research Spec"
    Path = "specs\research-spec.md"
    Required = @("Decision To Inform", "Research Question", "Hypothesis", "Method", "Metrics and Decision Thresholds")
  },
  @{
    Name = "Customer Request"
    Path = "backlog\customer-request.md"
     Required = @("Title", "Description", "Context", "Acceptance Criteria", "Readiness Verdict", "Source References", "Scope", "Out of Scope", "Assumptions", "Dependencies", "Estimate", "Priority", "QA Evidence", "Technical Notes", "Failed Gates", "Missing Sources")
  }
)

$errors = @()

foreach ($check in $checks) {
  $fullPath = Join-Path $templatesRoot $check.Path
  if (-not (Test-Path $fullPath)) {
    $errors += "[$($check.Name)] Missing file: docs/templates/$($check.Path)"
    continue
  }

  $content = Get-Content -Raw $fullPath
  foreach ($field in $check.Required) {
    if ($content -notmatch [regex]::Escape($field)) {
      $errors += "[$($check.Name)] Missing expected field text: $field"
    }
  }
}

if (-not (Test-Path $designBriefSchemaPath)) {
  $errors += "[Design Brief Schema] Missing file: docs/templates/schemas/design-brief.schema.json"
} else {
  try {
    $schema = Get-Content -Raw $designBriefSchemaPath | ConvertFrom-Json
    if ($schema.type -ne "object") {
      $errors += "[Design Brief Schema] Root type must be object."
    }
    $requiredTopLevel = @(
      "overview",
      "problem_definition",
      "desired_outcome",
      "scope",
      "experience_definition",
      "dependencies",
      "success_criteria",
      "design_deliverables"
    )
    $schemaRequired = @($schema.required)
    foreach ($field in $requiredTopLevel) {
      if ($schemaRequired -notcontains $field) {
        $errors += "[Design Brief Schema] Missing required top-level field: $field"
      }
    }
  } catch {
    $errors += "[Design Brief Schema] Invalid JSON: docs/templates/schemas/design-brief.schema.json"
  }
}

foreach ($relativePath in $dorSchemaPaths) {
  $schemaPath = Join-Path $templatesRoot $relativePath
  if (-not (Test-Path $schemaPath)) {
    $errors += "[DoR Schema] Missing file: docs/templates/$relativePath"
    continue
  }

  try {
    $schema = Get-Content -Raw $schemaPath | ConvertFrom-Json
    if ($schema.type -ne "object") {
      $errors += "[DoR Schema] Root type must be object: docs/templates/$relativePath"
    }
    $schemaRequired = @($schema.required)
    foreach ($field in @("artifact_type","title","business_context","technical_context","validation_context","execution_governance","source_references","readiness")) {
      if ($schemaRequired -notcontains $field) {
        $errors += "[DoR Schema] Missing required field '$field': docs/templates/$relativePath"
      }
    }
  } catch {
    $errors += "[DoR Schema] Invalid JSON: docs/templates/$relativePath"
  }
}

if ($errors.Count -gt 0) {
  Write-Host "Template smoke test failed:" -ForegroundColor Red
  $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "Template smoke test passed." -ForegroundColor Green
exit 0
