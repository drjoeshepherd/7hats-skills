$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $root "skills"

if (-not (Test-Path $skillsRoot)) {
  throw "Missing skills directory: $skillsRoot"
}

$requiredSkills = @(
  "7hats-orchestrator",
  "7hats-product",
  "7hats-researcher",
  "7hats-designer",
  "7hats-engineer",
  "7hats-marketer",
  "7hats-entrepreneur",
  "7hats-meta"
)

$errors = @()

foreach ($skill in $requiredSkills) {
  $dir = Join-Path $skillsRoot $skill
  if (-not (Test-Path $dir)) {
    $errors += "Missing skill folder: $skill"
    continue
  }

  $skillMd = Join-Path $dir "SKILL.md"
  $openaiYaml = Join-Path $dir "agents\openai.yaml"

  if (-not (Test-Path $skillMd)) { $errors += "Missing SKILL.md: $skill" }
  if (-not (Test-Path $openaiYaml)) { $errors += "Missing agents/openai.yaml: $skill" }

  if (Test-Path $skillMd) {
    $content = Get-Content -Raw $skillMd
    if ($content -notmatch "(?ms)^---\s*name:\s*[^\r\n]+\s*description:\s*[^\r\n]+\s*---") {
      $errors += "Invalid frontmatter (name/description): $skill"
    }
    foreach ($section in @("## Load Order","## Workflow","## Output Contract","## Failure/Refinement Behavior")) {
      if ($content -notmatch [regex]::Escape($section)) {
        $errors += "Missing section '$section' in $skill"
      }
    }
  }
}

if ($errors.Count -gt 0) {
  Write-Host "Validation failed:" -ForegroundColor Red
  $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "Validation passed." -ForegroundColor Green
exit 0


