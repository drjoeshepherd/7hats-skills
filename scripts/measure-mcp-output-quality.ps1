param(
  [Parameter(Mandatory = $true)]
  [string]$InputJsonlPath
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $InputJsonlPath)) {
  throw "Input file not found: $InputJsonlPath"
}

$rows = Get-Content $InputJsonlPath | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
  try { $_ | ConvertFrom-Json } catch { $null }
} | Where-Object { $null -ne $_ }

if (@($rows).Count -eq 0) {
  throw "No valid JSON records found in: $InputJsonlPath"
}

function Percent {
  param([int]$Num, [int]$Den)
  if ($Den -le 0) { return 0 }
  return [Math]::Round((100.0 * $Num / $Den), 2)
}

$create = @($rows | Where-Object { $_.tool -eq "create_artifact" -or $_.artifact_type })
$route = @($rows | Where-Object { $_.tool -eq "route_hat" -or $_.deterministic_signature })

$qualityEnvelopePass = @($create | Where-Object {
  $_.PSObject.Properties.Name -contains "readiness_verdict" -and
  $_.PSObject.Properties.Name -contains "score" -and
  $_.PSObject.Properties.Name -contains "assumptions" -and
  $_.PSObject.Properties.Name -contains "open_questions" -and
  $_.PSObject.Properties.Name -contains "next_best_action"
}).Count

$repoAwareCreate = @($create | Where-Object { $_.repo_mode -eq "repo_aware" })
$repoAwareCitationsPass = @($repoAwareCreate | Where-Object {
  ($_.PSObject.Properties.Name -contains "source_citations") -and
  (@($_.source_citations).Count -ge 2)
}).Count

$reasoningTracePass = @($rows | Where-Object {
  $_.PSObject.Properties.Name -contains "reasoning_trace"
}).Count

$collabReceiptPass = @($create | Where-Object {
  $_.PSObject.Properties.Name -contains "orchestration_receipt" -and
  $_.orchestration_receipt.PSObject.Properties.Name -contains "required_outputs" -and
  $_.orchestration_receipt.PSObject.Properties.Name -contains "contribution_summary" -and
  $_.orchestration_receipt.PSObject.Properties.Name -contains "unresolved_risks" -and
  $_.orchestration_receipt.PSObject.Properties.Name -contains "receipt"
}).Count

$output = [ordered]@{
  records_total = @($rows).Count
  create_artifact_total = @($create).Count
  route_hat_total = @($route).Count
  quality_envelope_coverage_pct = Percent -Num $qualityEnvelopePass -Den @($create).Count
  repo_aware_structured_citation_coverage_pct = Percent -Num $repoAwareCitationsPass -Den @($repoAwareCreate).Count
  reasoning_trace_coverage_pct = Percent -Num $reasoningTracePass -Den @($rows).Count
  collaboration_receipt_coverage_pct = Percent -Num $collabReceiptPass -Den @($create).Count
}

$output | ConvertTo-Json -Depth 10

