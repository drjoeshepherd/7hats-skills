$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$templatesRoot = Join-Path $root "docs\templates"

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
    Required = @("Problem/Opportunity Statement", "Business Outcome", "In Scope", "Out of Scope", "Success Metrics")
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
    Required = @("Goals", "Non-Goals", "User Flows", "Accessibility Requirements", "Risks and Mitigations")
  },
  @{
    Name = "Research Spec"
    Path = "specs\research-spec.md"
    Required = @("Decision To Inform", "Research Question", "Hypothesis", "Method", "Metrics and Decision Thresholds")
  },
  @{
    Name = "Customer Request"
    Path = "backlog\customer-request.md"
    Required = @("Tenant Context", "Scope", "Out of Scope", "Acceptance Criteria", "Source References")
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

if ($errors.Count -gt 0) {
  Write-Host "Template smoke test failed:" -ForegroundColor Red
  $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "Template smoke test passed." -ForegroundColor Green
exit 0
