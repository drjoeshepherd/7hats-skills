$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $root "skills"
$templatesRoot = Join-Path $root "docs\templates"

if (-not (Test-Path $skillsRoot)) {
  throw "Missing skills directory: $skillsRoot"
}

if (-not (Test-Path $templatesRoot)) {
  throw "Missing templates directory: $templatesRoot"
}

$requiredSkills = @(
  "7hats",
  "7hats-craft",
  "7hats-research",
  "7hats-design",
  "7hats-engineer",
  "7hats-market",
  "7hats-entrepreneur",
  "7hats-human",
  # legacy names retained
  "7hats-orchestrator",
  "7hats-product",
  "7hats-researcher",
  "7hats-designer",
  "7hats-marketer",
  "7hats-meta"
)

$errors = @()

$requiredTemplateFiles = @(
  "README.md",
  "backlog\mission.md",
  "backlog\signal.md",
  "backlog\epic.md",
  "backlog\user-story.md",
  "backlog\bug.md",
  "backlog\feature.md",
  "backlog\customer-request.md",
  "specs\design-spec.md",
  "specs\research-spec.md"
)

foreach ($relativePath in $requiredTemplateFiles) {
  $fullPath = Join-Path $templatesRoot $relativePath
  if (-not (Test-Path $fullPath)) {
    $errors += "Missing template file: docs/templates/$relativePath"
  }
}

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


