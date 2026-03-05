$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$schemasRoot = Join-Path $root "docs\mcp\schemas"
$contractMapPath = Join-Path $root "mcp\server\contract-map.json"

if (-not (Test-Path $schemasRoot)) {
  throw "Missing MCP schema folder: $schemasRoot"
}

$required = @(
  "route_hat.request.json",
  "route_hat.response.json",
  "create_artifact.request.json",
  "create_artifact.response.json",
  "validate_artifact.request.json",
  "validate_artifact.response.json",
  "list_templates.request.json",
  "list_templates.response.json",
  "get_template.request.json",
  "get_template.response.json"
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

if (-not (Test-Path $contractMapPath)) {
  $errors += "Missing contract map: mcp/server/contract-map.json"
} else {
  try {
    $contractMap = Get-Content -Raw $contractMapPath | ConvertFrom-Json
    foreach ($tool in $contractMap.tools) {
      foreach ($schemaPath in @($tool.request_schema, $tool.response_schema)) {
        if ([string]::IsNullOrWhiteSpace($schemaPath)) {
          $errors += "Empty schema path in contract map for tool: $($tool.name)"
          continue
        }
        $fullPath = Join-Path $root $schemaPath
        if (-not (Test-Path $fullPath)) {
          $errors += "Contract-map schema missing on disk: $schemaPath"
        }
      }
    }
  } catch {
    $errors += "Invalid JSON in mcp/server/contract-map.json"
  }
}

function Assert-SchemaField {
  param(
    [string]$SchemaName,
    [string[]]$RequiredFields
  )
  $path = Join-Path $schemasRoot $SchemaName
  if (-not (Test-Path $path)) { return }
  try {
    $schema = Get-Content -Raw $path | ConvertFrom-Json
  } catch {
    return
  }

  $requiredJson = $schema.required | ConvertTo-Json -Compress
  $propertiesJson = $schema.properties | ConvertTo-Json -Depth 20 -Compress

  foreach ($field in $RequiredFields) {
    $requiredPattern = '"' + [regex]::Escape($field) + '"'
    if (($requiredJson -notmatch $requiredPattern) -and ($propertiesJson -notmatch $requiredPattern)) {
      $errors += "Schema missing expected field '$field': docs/mcp/schemas/$SchemaName"
    }
  }
}

# Deterministic routing/validation expectations for Phase 4
Assert-SchemaField -SchemaName "route_hat.request.json" -RequiredFields @("intent", "repo_context")
Assert-SchemaField -SchemaName "route_hat.response.json" -RequiredFields @(
  "intent",
  "repo_mode",
  "routing_confidence",
  "deterministic_signature",
  "orchestration_receipt",
  "reasoning_trace",
  "trace_id",
  "schema_version"
)
Assert-SchemaField -SchemaName "create_artifact.request.json" -RequiredFields @("source_references")
Assert-SchemaField -SchemaName "create_artifact.response.json" -RequiredFields @(
  "reasoning_trace",
  "source_citations",
  "next_best_action",
  "score",
  "required_outputs",
  "contribution_summary",
  "unresolved_risks",
  "receipt"
)
Assert-SchemaField -SchemaName "validate_artifact.request.json" -RequiredFields @("repo_mode", "intent")
Assert-SchemaField -SchemaName "validate_artifact.response.json" -RequiredFields @(
  "deterministic_violations",
  "validation_profile",
  "findings",
  "score_breakdown",
  "artifact_completeness"
)
Assert-SchemaField -SchemaName "validate_artifact.request.json" -RequiredFields @("expected_artifacts")

if ($errors.Count -gt 0) {
  Write-Host "MCP schema smoke test failed:" -ForegroundColor Red
  $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "MCP schema smoke test passed." -ForegroundColor Green
exit 0
