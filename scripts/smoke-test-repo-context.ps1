$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $root "skills"
$docsRoot = Join-Path $root "docs\operating-system"

$errors = @()

$repoGatePath = Join-Path $docsRoot "repo-context-gate.md"
if (-not (Test-Path $repoGatePath)) {
  $errors += "Missing repo context gate doc: docs/operating-system/repo-context-gate.md"
} else {
  $repoGate = Get-Content -Raw $repoGatePath
  foreach ($requiredText in @(
    "## Mode Detection",
    "Repo-Aware Mode",
    "Generic Mode",
    "Unknown - needs discovery",
    "Readiness Verdict: Needs Refinement",
    "## Minimum Citation Rule",
    "One architecture/service reference.",
    "One implementation/mapping/code reference."
  )) {
    if ($repoGate -notmatch [regex]::Escape($requiredText)) {
      $errors += "Missing repo gate requirement '$requiredText'"
    }
  }
}

$routerSkills = @(
  "7hats\SKILL.md",
  "7hats-orchestrator\SKILL.md"
)
foreach ($relativePath in $routerSkills) {
  $path = Join-Path $skillsRoot $relativePath
  if (-not (Test-Path $path)) {
    $errors += "Missing router skill file: skills/$relativePath"
    continue
  }
  $content = Get-Content -Raw $path
  foreach ($requiredText in @(
    "Detect repo mode",
    "Repo-Aware Mode",
    "Generic Mode",
    "Enforce repo mode behavior"
  )) {
    if ($content -notmatch [regex]::Escape($requiredText)) {
      $errors += "Missing repo mode text '$requiredText' in skills/$relativePath"
    }
  }
}

$contractFiles = @(
  "7hats\references\output-contracts.md",
  "7hats-orchestrator\references\output-contracts.md"
)
foreach ($relativePath in $contractFiles) {
  $path = Join-Path $skillsRoot $relativePath
  if (-not (Test-Path $path)) {
    $errors += "Missing output contracts file: skills/$relativePath"
    continue
  }
  $content = Get-Content -Raw $path
  foreach ($requiredText in @(
    "## Repo Context Gate",
    "Repo-Aware Mode",
    "Generic Mode",
    "Unknown - needs discovery",
    "Needs Refinement"
  )) {
    if ($content -notmatch [regex]::Escape($requiredText)) {
      $errors += "Missing repo-context contract text '$requiredText' in skills/$relativePath"
    }
  }
}

$hasGit = Test-Path (Join-Path $root ".git")
if (-not $hasGit) {
  $errors += "Expected attached repository context (.git) at workspace root for repo-aware smoke run."
}

if ($errors.Count -gt 0) {
  Write-Host "Repo-context smoke test failed:" -ForegroundColor Red
  $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "Repo-context smoke test passed." -ForegroundColor Green
exit 0

