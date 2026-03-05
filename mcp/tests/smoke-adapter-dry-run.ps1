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
  $repoAwareStructuredPath = Join-Path $payloadRoot "route-hat.repo-aware.structured.json"
  $genericPath = Join-Path $payloadRoot "route-hat.generic.json"
  $createPath = Join-Path $payloadRoot "create-artifact.repo-aware.structured.json"
  $createLegacyPath = Join-Path $payloadRoot "create-artifact.repo-aware.legacy-refs.json"
  $validatePath = Join-Path $payloadRoot "validate-artifact.sample.json"
  $validateMaterializationPath = Join-Path $payloadRoot "validate-artifact.materialization.sample.json"

  foreach ($path in @($repoAwarePath, $repoAwareStructuredPath, $genericPath, $createPath, $createLegacyPath, $validatePath, $validateMaterializationPath)) {
    if (-not (Test-Path $path)) {
      $errors += "Missing payload file: $path"
    }
  }

  if ($errors.Count -eq 0) {
    $allowedHats = @("product_owner", "researcher", "designer", "engineer", "marketer", "entrepreneur", "meta")
    $allowedConstraints = @("ambiguity", "execution_planning", "risk_nfr", "option_conflict", "quality_gate_check", "delivery_drift")

    $routeAwareA = Invoke-Adapter -Tool "route_hat" -RequestPath $repoAwarePath
    $routeAwareB = Invoke-Adapter -Tool "route_hat" -RequestPath $repoAwarePath
    if ($routeAwareA.repo_mode -ne "repo_aware") {
      $errors += "Expected repo_aware mode for attached repo payload."
    }
    if ($routeAwareA.deterministic_signature -ne $routeAwareB.deterministic_signature) {
      $errors += "Deterministic signature mismatch for identical route_hat input."
    }
    if (-not ($allowedHats -contains [string]$routeAwareA.primary_hat)) {
      $errors += "route_hat primary_hat is outside expected enum."
    }
    if (-not ($allowedConstraints -contains [string]$routeAwareA.constraint_classification)) {
      $errors += "route_hat constraint_classification is outside expected enum."
    }
    if (-not $routeAwareA.PSObject.Properties.Name.Contains("reasoning_trace")) {
      $errors += "route_hat response missing reasoning_trace."
    }
    if (-not $routeAwareA.PSObject.Properties.Name.Contains("trace_id")) {
      $errors += "route_hat response missing trace_id."
    }

    $routeGeneric = Invoke-Adapter -Tool "route_hat" -RequestPath $genericPath
    if ($routeGeneric.repo_mode -ne "generic") {
      $errors += "Expected generic mode for detached repo payload."
    }

    $routeStructured = Invoke-Adapter -Tool "route_hat" -RequestPath $repoAwareStructuredPath
    if ($routeStructured.repo_mode -ne "repo_aware") {
      $errors += "Expected repo_aware mode for structured repo payload."
    }

    $create = Invoke-Adapter -Tool "create_artifact" -RequestPath $createPath
    if ($create.readiness_verdict -ne "Ready") {
      $errors += "Expected create_artifact readiness_verdict=Ready for grounded structured refs."
    }
    if (-not $create.PSObject.Properties.Name.Contains("source_citations")) {
      $errors += "create_artifact response missing source_citations."
    } elseif (@($create.source_citations).Count -lt 2) {
      $errors += "create_artifact source_citations should include at least two references."
    }
    if (-not $create.PSObject.Properties.Name.Contains("reasoning_trace")) {
      $errors += "create_artifact response missing reasoning_trace."
    }
    if (-not $create.PSObject.Properties.Name.Contains("next_best_action")) {
      $errors += "create_artifact response missing next_best_action."
    }
    if (-not $create.PSObject.Properties.Name.Contains("orchestration_receipt")) {
      $errors += "create_artifact response missing orchestration_receipt."
    } else {
      $receipt = $create.orchestration_receipt
      if (-not $receipt.PSObject.Properties.Name.Contains("required_outputs")) {
        $errors += "create_artifact orchestration_receipt missing required_outputs."
      }
      if (-not $receipt.PSObject.Properties.Name.Contains("contribution_summary")) {
        $errors += "create_artifact orchestration_receipt missing contribution_summary."
      }
      if (-not $receipt.PSObject.Properties.Name.Contains("unresolved_risks")) {
        $errors += "create_artifact orchestration_receipt missing unresolved_risks."
      }
      if (-not $receipt.PSObject.Properties.Name.Contains("receipt")) {
        $errors += "create_artifact orchestration_receipt missing receipt."
      }
    }

    $createLegacy = Invoke-Adapter -Tool "create_artifact" -RequestPath $createLegacyPath
    if ($createLegacy.readiness_verdict -ne "Needs Refinement") {
      $errors += "Expected create_artifact readiness_verdict=Needs Refinement for repo-aware legacy string refs."
    }
    if (-not (@($createLegacy.failed_gates) -contains "Citation Format")) {
      $errors += "Expected failed_gates to include 'Citation Format' for legacy refs."
    }

    $validate = Invoke-Adapter -Tool "validate_artifact" -RequestPath $validatePath
    if ($validate.deterministic_violations -ne $true) {
      $errors += "validate_artifact should return deterministic_violations=true."
    }
    if (-not $validate.PSObject.Properties.Name.Contains("validation_profile")) {
      $errors += "validate_artifact response missing validation_profile."
    }
    if (-not $validate.PSObject.Properties.Name.Contains("findings")) {
      $errors += "validate_artifact response missing findings."
    }
    if (-not $validate.PSObject.Properties.Name.Contains("score_breakdown")) {
      $errors += "validate_artifact response missing score_breakdown."
    }
    if (-not $validate.PSObject.Properties.Name.Contains("artifact_completeness")) {
      $errors += "validate_artifact response missing artifact_completeness."
    }

    $validateMaterialization = Invoke-Adapter -Tool "validate_artifact" -RequestPath $validateMaterializationPath
    if ($validateMaterialization.artifact_completeness.complete -ne $false) {
      $errors += "Expected artifact_completeness.complete=false for missing expected artifacts."
    }
    if ($validateMaterialization.valid -ne $false) {
      $errors += "Expected validate_artifact valid=false when expected artifacts are missing."
    }
    $missingArtifactFinding = @($validateMaterialization.findings | Where-Object { $_.code -eq "MISSING_ARTIFACT_OUTPUT" })
    if ($missingArtifactFinding.Count -lt 1) {
      $errors += "Expected at least one MISSING_ARTIFACT_OUTPUT finding."
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
