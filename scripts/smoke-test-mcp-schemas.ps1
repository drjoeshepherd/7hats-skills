$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$schemasRoot = Join-Path $root "docs\mcp\schemas"

if (-not (Test-Path $schemasRoot)) {
  throw "Missing MCP schema folder: $schemasRoot"
}

$required = @(
  "route_hat.request.json",
  "route_hat.response.json",
  "create_artifact.request.json",
  "create_artifact.response.json"
)

$errors = @()

foreach ($name in $required) {
  $path = Join-Path $schemasRoot $name
  if (-not (Test-Path $path)) {
    $errors += "Missing schema file: docs/mcp/schemas/$name"
    continue
  }

  try {
    $null = Get-Content -Raw $path | ConvertFrom-Json
  } catch {
    $errors += "Invalid JSON in schema file: docs/mcp/schemas/$name"
  }
}

if ($errors.Count -gt 0) {
  Write-Host "MCP schema smoke test failed:" -ForegroundColor Red
  $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "MCP schema smoke test passed." -ForegroundColor Green
exit 0
