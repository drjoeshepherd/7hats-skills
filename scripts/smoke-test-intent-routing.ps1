$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $root "skills"
$docsRoot = Join-Path $root "docs\operating-system"

$errors = @()

$routingTablePath = Join-Path $docsRoot "routing-table.md"
if (-not (Test-Path $routingTablePath)) {
  $errors += "Missing routing table doc: docs/operating-system/routing-table.md"
} else {
  $routingTable = Get-Content -Raw $routingTablePath
  foreach ($intent in @("clarify","plan","de-risk","decide","validate","recover")) {
    if ($routingTable -notmatch [regex]::Escape($intent)) {
      $errors += "Missing intent in routing table: $intent"
    }
  }
}

$matrixFiles = @(
  "7hats\references\switching-matrix.md",
  "7hats-orchestrator\references\switching-matrix.md"
)
foreach ($relativePath in $matrixFiles) {
  $path = Join-Path $skillsRoot $relativePath
  if (-not (Test-Path $path)) {
    $errors += "Missing switching matrix: skills/$relativePath"
    continue
  }
  $content = Get-Content -Raw $path
  if ($content -notmatch [regex]::Escape("## Intent Routing (Primary)")) {
    $errors += "Missing intent routing section in skills/$relativePath"
  }
  foreach ($intent in @("clarify","plan","de-risk","decide","validate","recover")) {
    if ($content -notmatch [regex]::Escape($intent)) {
      $errors += "Missing intent $intent in skills/$relativePath"
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
    "Classify user intent",
    "clarify",
    "plan",
    "de-risk",
    "decide",
    "validate",
    "recover"
  )) {
    if ($content -notmatch [regex]::Escape($requiredText)) {
      $errors += "Missing intent parsing text '$requiredText' in skills/$relativePath"
    }
  }
}

$contractsPath = Join-Path $skillsRoot "7hats\references\output-contracts.md"
if (-not (Test-Path $contractsPath)) {
  $errors += "Missing canonical output contracts: skills/7hats/references/output-contracts.md"
} else {
  $contracts = Get-Content -Raw $contractsPath
  foreach ($line in @(
    "Story request -> return Story only.",
    "Mission request -> return Mission only.",
    "Signal request -> return Signal only.",
    "Mission/Signal breakdown request -> return story series only."
  )) {
    if ($contracts -notmatch [regex]::Escape($line)) {
      $errors += "Missing output-scope contract line: $line"
    }
  }
}

if ($errors.Count -gt 0) {
  Write-Host "Intent routing smoke test failed:" -ForegroundColor Red
  $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "Intent routing smoke test passed." -ForegroundColor Green
exit 0
