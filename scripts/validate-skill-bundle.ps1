$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $root "skills"
$templatesRoot = Join-Path $root "docs\templates"
$operatingSystemRoot = Join-Path $root "docs\operating-system"
$scriptsRoot = Join-Path $root "scripts"
$mcpDocsRoot = Join-Path $root "docs\mcp"
$mcpServerRoot = Join-Path $root "mcp\server"
$mcpTestsRoot = Join-Path $root "mcp\tests"

if (-not (Test-Path $skillsRoot)) {
  throw "Missing skills directory: $skillsRoot"
}

if (-not (Test-Path $templatesRoot)) {
  throw "Missing templates directory: $templatesRoot"
}

if (-not (Test-Path $operatingSystemRoot)) {
  throw "Missing operating-system docs directory: $operatingSystemRoot"
}

$requiredSkills = @(
  "7hats",
  "7hats-craft",
  "7hats-analyze-backlog",
  "7hats-slice-work",
  "7hats-roadmap",
  "7hats-estimate",
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
  "specs\research-spec.md",
  "schemas\design-brief.schema.json"
)

$requiredOperatingSystemFiles = @(
  "intent-taxonomy.md",
  "routing-table.md",
  "handoff-contract.md",
  "trigger-schema.md",
  "repo-context-gate.md",
  "capability-catalog.md"
)

$requiredSmokeScripts = @(
  "smoke-test-routing.ps1",
  "smoke-test-templates.ps1",
  "smoke-test-intent-routing.ps1",
  "smoke-test-repo-context.ps1",
  "smoke-test-mcp-schemas.ps1"
)

$requiredAdditionalDocs = @(
  "docs/mcp/integration-quickstart.md",
  "docs/intent-first-migration.md"
)

$requiredMcpFiles = @(
  "mcp/server/adapter.ps1",
  "mcp/tests/smoke-adapter-dry-run.ps1"
)

foreach ($relativePath in $requiredTemplateFiles) {
  $fullPath = Join-Path $templatesRoot $relativePath
  if (-not (Test-Path $fullPath)) {
    $errors += "Missing template file: docs/templates/$relativePath"
  }
}

foreach ($relativePath in $requiredOperatingSystemFiles) {
  $fullPath = Join-Path $operatingSystemRoot $relativePath
  if (-not (Test-Path $fullPath)) {
    $errors += "Missing operating-system file: docs/operating-system/$relativePath"
  }
}

foreach ($scriptName in $requiredSmokeScripts) {
  $fullPath = Join-Path $scriptsRoot $scriptName
  if (-not (Test-Path $fullPath)) {
    $errors += "Missing smoke script: scripts/$scriptName"
  }
}

foreach ($docPath in $requiredAdditionalDocs) {
  $fullPath = Join-Path $root $docPath
  if (-not (Test-Path $fullPath)) {
    $errors += "Missing required documentation: $docPath"
  }
}

foreach ($filePath in $requiredMcpFiles) {
  $fullPath = Join-Path $root $filePath
  if (-not (Test-Path $fullPath)) {
    $errors += "Missing required MCP implementation/test file: $filePath"
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

$intentAwareSkills = @("7hats", "7hats-orchestrator")
foreach ($skill in $intentAwareSkills) {
  $skillPath = Join-Path $skillsRoot "$skill\SKILL.md"
  if (Test-Path $skillPath) {
    $content = Get-Content -Raw $skillPath
    foreach ($requiredText in @(
      "docs/operating-system/intent-taxonomy.md",
      "docs/operating-system/routing-table.md",
      "docs/operating-system/repo-context-gate.md",
      "docs/operating-system/capability-catalog.md",
      "Repo-Aware Mode",
      "Generic Mode"
    )) {
      if ($content -notmatch [regex]::Escape($requiredText)) {
        $errors += "Missing intent/repo-context requirement '$requiredText' in $skill/ SKILL.md"
      }
    }
  }
}

$canonicalContracts = Join-Path $skillsRoot "7hats\references\output-contracts.md"
if (Test-Path $canonicalContracts) {
  $content = Get-Content -Raw $canonicalContracts
  foreach ($requiredText in @(
    "## Repo Context Gate",
    "Repo-Aware Mode",
    "Generic Mode",
    "Unknown - needs discovery",
    "## Internal Scaffolding Rule"
  )) {
    if ($content -notmatch [regex]::Escape($requiredText)) {
      $errors += "Missing output contract text '$requiredText' in skills/7hats/references/output-contracts.md"
    }
  }
} else {
  $errors += "Missing canonical output contracts file: skills/7hats/references/output-contracts.md"
}

$canonicalPlaybooks = @(
  "7hats-product\references\playbooks.md",
  "7hats-craft\references\playbooks.md",
  "7hats-research\references\playbooks.md",
  "7hats-design\references\playbooks.md",
  "7hats-engineer\references\playbooks.md",
  "7hats-market\references\playbooks.md",
  "7hats-entrepreneur\references\playbooks.md",
  "7hats-human\references\playbooks.md"
)
foreach ($relativePath in $canonicalPlaybooks) {
  $path = Join-Path $skillsRoot $relativePath
  if (-not (Test-Path $path)) {
    $errors += "Missing canonical playbook file: skills/$relativePath"
    continue
  }
  $content = Get-Content -Raw $path
  if ($content -notmatch [regex]::Escape("## Internal Micro-Steps (Callable)")) {
    $errors += "Missing internal micro-steps section in skills/$relativePath"
  }
}

if ($errors.Count -gt 0) {
  Write-Host "Validation failed:" -ForegroundColor Red
  $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "Validation passed." -ForegroundColor Green
exit 0



