$ErrorActionPreference = "Stop"

$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$adapterPath = Join-Path $root "mcp\server\adapter.ps1"
$payloadRoot = Join-Path $root "mcp\tests\payloads"

$errors = @()

if (-not (Test-Path $adapterPath)) {
  throw "Missing adapter script: $adapterPath"
}

function Invoke-Adapter {
  param(
    [string]$Tool,
    [string]$RequestPath
  )
  $raw = & $adapterPath -Tool $Tool -RequestPath $RequestPath
  if ([string]::IsNullOrWhiteSpace($raw)) {
    throw "Adapter returned empty response for tool: $Tool"
  }
  return ($raw | ConvertFrom-Json)
}

try {
  $repoAwarePath = Join-Path $payloadRoot "route-hat.repo-aware.json"
  $genericPath = Join-Path $payloadRoot "route-hat.generic.json"
  $validatePath = Join-Path $payloadRoot "validate-artifact.sample.json"

  foreach ($path in @($repoAwarePath, $genericPath, $validatePath)) {
    if (-not (Test-Path $path)) {
      $errors += "Missing payload file: $path"
    }
  }

  if ($errors.Count -eq 0) {
    $routeAwareA = Invoke-Adapter -Tool "route_hat" -RequestPath $repoAwarePath
    $routeAwareB = Invoke-Adapter -Tool "route_hat" -RequestPath $repoAwarePath
    if ($routeAwareA.repo_mode -ne "repo_aware") {
      $errors += "Expected repo_aware mode for attached repo payload."
    }
    if ($routeAwareA.deterministic_signature -ne $routeAwareB.deterministic_signature) {
      $errors += "Deterministic signature mismatch for identical route_hat input."
    }

    $routeGeneric = Invoke-Adapter -Tool "route_hat" -RequestPath $genericPath
    if ($routeGeneric.repo_mode -ne "generic") {
      $errors += "Expected generic mode for detached repo payload."
    }

    $validate = Invoke-Adapter -Tool "validate_artifact" -RequestPath $validatePath
    if ($validate.deterministic_violations -ne $true) {
      $errors += "validate_artifact should return deterministic_violations=true."
    }
    if (-not $validate.PSObject.Properties.Name.Contains("validation_profile")) {
      $errors += "validate_artifact response missing validation_profile."
    }

  }
} catch {
  $errors += $_.Exception.Message
}

if ($errors.Count -gt 0) {
  Write-Host "MCP adapter dry-run smoke test failed:" -ForegroundColor Red
  $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "MCP adapter dry-run smoke test passed." -ForegroundColor Green
exit 0
