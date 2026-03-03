$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $root "skills"

if (-not (Test-Path $skillsRoot)) {
  throw "Missing skills directory: $skillsRoot"
}

$aliasMap = @(
  @{ Alias = "7hats"; Target = "7hats-orchestrator" },
  @{ Alias = "7hats-craft"; Target = "7hats-product" },
  @{ Alias = "7hats-research"; Target = "7hats-researcher" },
  @{ Alias = "7hats-design"; Target = "7hats-designer" },
  @{ Alias = "7hats-engineer"; Target = "7hats-engineer" },
  @{ Alias = "7hats-market"; Target = "7hats-marketer" },
  @{ Alias = "7hats-entrepreneur"; Target = "7hats-entrepreneur" },
  @{ Alias = "7hats-human"; Target = "7hats-meta" }
)

$errors = @()

foreach ($pair in $aliasMap) {
  $aliasDir = Join-Path $skillsRoot $pair.Alias
  $targetDir = Join-Path $skillsRoot $pair.Target

  if (-not (Test-Path $aliasDir)) {
    $errors += "Missing alias skill folder: $($pair.Alias)"
    continue
  }
  if (-not (Test-Path $targetDir)) {
    $errors += "Missing target skill folder: $($pair.Target)"
    continue
  }

  $aliasSkill = Join-Path $aliasDir "SKILL.md"
  $targetSkill = Join-Path $targetDir "SKILL.md"
  $aliasYaml = Join-Path $aliasDir "agents\openai.yaml"
  $targetYaml = Join-Path $targetDir "agents\openai.yaml"

  foreach ($path in @($aliasSkill, $targetSkill, $aliasYaml, $targetYaml)) {
    if (-not (Test-Path $path)) {
      $errors += "Missing required file: $path"
    }
  }

  if (Test-Path $aliasSkill) {
    $content = Get-Content -Raw $aliasSkill
    if ($content -notmatch ("(?m)^name:\s*" + [regex]::Escape($pair.Alias) + "\s*$")) {
      $errors += "Alias SKILL frontmatter name mismatch in $($pair.Alias)"
    }
  }

  if ((Test-Path $aliasYaml) -and (Test-Path $targetYaml)) {
    $aliasPromptLine = (Get-Content $aliasYaml | Where-Object { $_ -match "^default_prompt:\s*" })
    $targetPromptLine = (Get-Content $targetYaml | Where-Object { $_ -match "^default_prompt:\s*" })
    if (($aliasPromptLine.Count -eq 0) -or ($targetPromptLine.Count -eq 0)) {
      $errors += "Missing default_prompt in alias or target yaml: $($pair.Alias) -> $($pair.Target)"
    } elseif ($aliasPromptLine[0] -ne $targetPromptLine[0]) {
      $errors += "default_prompt drift detected: $($pair.Alias) != $($pair.Target)"
    }
  }
}

$orchestratorContracts = Join-Path $skillsRoot "7hats\references\output-contracts.md"
if (-not (Test-Path $orchestratorContracts)) {
  $errors += "Missing routing output contracts: $orchestratorContracts"
} else {
  $contracts = Get-Content -Raw $orchestratorContracts
  $requiredContractLines = @(
    "Story request -> return Story only.",
    "Mission request -> return Mission only.",
    "Signal request -> return Signal only.",
    "Mission/Signal breakdown request -> return story series only."
  )
  foreach ($line in $requiredContractLines) {
    if ($contracts -notmatch [regex]::Escape($line)) {
      $errors += "Missing output-scope contract line: $line"
    }
  }
}

$entrepreneurTypoPath = Join-Path $skillsRoot "7hats-entreprenuer"
if (Test-Path $entrepreneurTypoPath) {
  $errors += "Deprecated typo alias still exists: skills/7hats-entreprenuer"
}

if ($errors.Count -gt 0) {
  Write-Host "Routing smoke test failed:" -ForegroundColor Red
  $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "Routing smoke test passed." -ForegroundColor Green
exit 0
