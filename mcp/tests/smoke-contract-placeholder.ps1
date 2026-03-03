$ErrorActionPreference = "Stop"

$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$contractSpec = Join-Path $root "docs\mcp\contract-spec.md"
$contractMap = Join-Path $root "mcp\server\contract-map.json"

$errors = @()

if (-not (Test-Path $contractSpec)) {
  $errors += "Missing MCP contract spec: docs/mcp/contract-spec.md"
}

if (-not (Test-Path $contractMap)) {
  $errors += "Missing contract map: mcp/server/contract-map.json"
}

if (Test-Path $contractMap) {
  $json = Get-Content -Raw $contractMap | ConvertFrom-Json
  $requiredTools = @(
    "route_hat",
    "create_artifact",
    "validate_artifact",
    "list_templates",
    "get_template"
  )

  foreach ($tool in $requiredTools) {
    if (-not ($json.tools | Where-Object { $_.name -eq $tool })) {
      $errors += "Missing required MCP tool in contract map: $tool"
    }
  }
}

if ($errors.Count -gt 0) {
  Write-Host "MCP contract placeholder smoke test failed:" -ForegroundColor Red
  $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "MCP contract placeholder smoke test passed." -ForegroundColor Green
exit 0
