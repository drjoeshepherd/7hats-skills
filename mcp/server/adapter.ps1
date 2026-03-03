param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("route_hat", "create_artifact", "validate_artifact", "list_templates", "get_template")]
  [string]$Tool,

  [string]$RequestPath,
  [string]$RequestJson
)

$ErrorActionPreference = "Stop"

$contractVersion = "1.1.0"
$templateVersion = "v1"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

function Get-JsonRequest {
  if (-not [string]::IsNullOrWhiteSpace($RequestJson)) {
    return ($RequestJson | ConvertFrom-Json)
  }
  if (-not [string]::IsNullOrWhiteSpace($RequestPath)) {
    return (Get-Content -Raw $RequestPath | ConvertFrom-Json)
  }
  return [pscustomobject]@{}
}

function Has-Key {
  param([object]$Obj, [string]$Key)
  if ($null -eq $Obj) { return $false }
  if ($Obj -is [hashtable]) { return $Obj.ContainsKey($Key) }
  return ($Obj.PSObject.Properties.Name -contains $Key)
}

function Coalesce-String {
  param([object]$Value, [string]$Fallback = "")
  if ($null -eq $Value) { return $Fallback }
  $s = [string]$Value
  if ([string]::IsNullOrWhiteSpace($s)) { return $Fallback }
  return $s
}

function Get-RepoMode {
  param([object]$Request)

  if (Has-Key $Request "repo_mode") {
    if ($Request.repo_mode -eq "repo_aware" -or $Request.repo_mode -eq "generic") {
      return $Request.repo_mode
    }
  }

  if (Has-Key $Request "repo_context" -and $Request.repo_context -ne $null) {
    $ctx = $Request.repo_context
    if ($ctx.attached -eq $false) { return "generic" }
    if ($ctx.attached -eq $true) {
      if ($ctx.mode_hint -eq "repo_aware" -or $ctx.mode_hint -eq "generic") {
        return $ctx.mode_hint
      }
      return "repo_aware"
    }
  }

  if (Test-Path (Join-Path $repoRoot ".git")) { return "repo_aware" }
  return "generic"
}

function Get-Intent {
  param([object]$Request)

  if (Has-Key $Request "intent") { return $Request.intent }
  $text = ""
  if (Has-Key $Request "request_text") { $text = [string]$Request.request_text }
  $text = $text.ToLowerInvariant()
  if ($text -match "\bde-risk\b|\brisk\b|\breliab|nfr|failure|rollback") { return "de-risk" }
  if ($text -match "\bdecide\b|\btradeoff\b|\boption\b|\bchoose\b") { return "decide" }
  if ($text -match "\bvalidate\b|\bready\b|\bdor\b|\bcheck\b") { return "validate" }
  if ($text -match "\brecover\b|\bdrift\b|\bblocked\b|\bstalled\b") { return "recover" }
  if ($text -match "\bplan\b|\bbreak down\b|\bdecompose\b|\bsprint\b") { return "plan" }
  return "clarify"
}

function Get-ArtifactType {
  param([object]$Request)
  if (Has-Key $Request "artifact_type") { return [string]$Request.artifact_type }
  return "user_story"
}

function Get-DeterministicSignature {
  param([string]$Value)
  $sha = [System.Security.Cryptography.SHA256]::Create()
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value.ToLowerInvariant().Trim())
  $hash = $sha.ComputeHash($bytes)
  ($hash | ForEach-Object { $_.ToString("x2") }) -join ""
}

function Get-HatPlan {
  param([string]$Intent)

  switch ($Intent) {
    "clarify" {
      return @{
        primary = "7hats-craft"
        secondary = @("7hats-research", "7hats-design")
        micro = @("craft.frame_outcome", "craft.bound_scope", "craft.write_acceptance")
      }
    }
    "plan" {
      return @{
        primary = "7hats-craft"
        secondary = @("7hats-engineer", "7hats-research")
        micro = @("craft.slice_vertical", "engineer.map_system", "craft.validate_readiness")
      }
    }
    "de-risk" {
      return @{
        primary = "7hats-engineer"
        secondary = @("7hats-research", "7hats-design", "7hats-entrepreneur")
        micro = @("engineer.model_constraints", "engineer.map_failures", "research.define_evidence_gate")
      }
    }
    "decide" {
      return @{
        primary = "7hats-human"
        secondary = @("7hats-entrepreneur", "7hats-craft", "7hats-engineer")
        micro = @("human.narrate_decision", "entrepreneur.articulate_opportunity_cost", "human.leave_receipt")
      }
    }
    "validate" {
      return @{
        primary = "7hats-craft"
        secondary = @("7hats-engineer", "7hats-design")
        micro = @("craft.validate_readiness", "engineer.define_eng_done", "design.map_experience_states")
      }
    }
    "recover" {
      return @{
        primary = "7hats-human"
        secondary = @("7hats-craft", "7hats-engineer", "7hats-market")
        micro = @("human.detect_drift", "human.enforce_transition", "market.monitor_post_launch_signal")
      }
    }
    default {
      return @{
        primary = "7hats-craft"
        secondary = @("7hats-research")
        micro = @("craft.frame_outcome")
      }
    }
  }
}

function Get-TemplateMap {
  return @{
    "mission" = "docs/templates/backlog/mission.md"
    "signal" = "docs/templates/backlog/signal.md"
    "epic" = "docs/templates/backlog/epic.md"
    "user_story" = "docs/templates/backlog/user-story.md"
    "bug" = "docs/templates/backlog/bug.md"
    "feature" = "docs/templates/backlog/feature.md"
    "customer_request" = "docs/templates/backlog/customer-request.md"
    "design_spec" = "docs/templates/specs/design-spec.md"
    "research_spec" = "docs/templates/specs/research-spec.md"
  }
}

function Assert-Contains {
  param([string]$Content, [string[]]$Needles)
  $missing = @()
  foreach ($needle in $Needles) {
    if ($Content -notmatch [regex]::Escape($needle)) { $missing += $needle }
  }
  return $missing
}

function Invoke-RouteHat {
  param([object]$Request)
  $intent = Get-Intent -Request $Request
  $repoMode = Get-RepoMode -Request $Request
  $artifactType = Get-ArtifactType -Request $Request
  $plan = Get-HatPlan -Intent $intent

  $requestText = Coalesce-String -Value $Request.request_text -Fallback ""
  $sourceText = "{0}|{1}|{2}|{3}" -f $requestText, $intent, $artifactType, $repoMode
  $sig = Get-DeterministicSignature -Value $sourceText

  return @{
    primary_hat = $plan.primary
    secondary_hats = $plan.secondary
    constraint_classification = $intent
    intent = $intent
    repo_mode = $repoMode
    artifact_type = $artifactType
    rationale = "Intent-first routing selected from deterministic rules."
    routing_confidence = "high"
    deterministic_signature = $sig
    orchestration_receipt = @{
      micro_steps = $plan.micro
      handoff_sequence = @(
        @{
          from_hat = $plan.primary
          to_hat = ($plan.secondary | Select-Object -First 1)
          reason = "Secondary constraint coverage."
        }
      )
      guardrails = @(
        "request-scoped-output-only",
        "repo-context-gate-enforced"
      )
    }
    contract_version = $contractVersion
  }
}

function Invoke-CreateArtifact {
  param([object]$Request)
  $intent = Get-Intent -Request $Request
  $repoMode = Get-RepoMode -Request $Request
  $artifactType = Get-ArtifactType -Request $Request
  $outputFormat = if (Has-Key $Request "output_format") { $Request.output_format } else { "markdown" }
  $sourceRefs = @()
  if (Has-Key $Request "source_references" -and $Request.source_references -ne $null) {
    $sourceRefs = @($Request.source_references)
  }

  $groundingStatus = if ($repoMode -eq "repo_aware" -and $sourceRefs.Count -lt 2) { "insufficient" } elseif ($sourceRefs.Count -ge 2) { "grounded" } else { "partial" }
  $readiness = if ($groundingStatus -eq "insufficient") { "Needs Refinement" } else { "Ready" }

  $requestText = Coalesce-String -Value $Request.request_text -Fallback "Generated artifact content."
  $markdown = @"
# $artifactType

## Description
$requestText

## Source References
$(
  if ($sourceRefs.Count -gt 0) { ($sourceRefs | ForEach-Object { "- $_" }) -join "`n" } else { "- Unknown - needs discovery" }
)
"@

  $contentJson = @{
    artifact_type = $artifactType
    intent = $intent
    summary = (Coalesce-String -Value $Request.request_text -Fallback "")
    source_references = $sourceRefs
  }

  $response = @{
    artifact_type = $artifactType
    readiness_verdict = $readiness
    repo_mode = $repoMode
    grounding_status = $groundingStatus
    template_version = $templateVersion
    contract_version = $contractVersion
    orchestration_receipt = @{
      intent = $intent
      micro_steps = (Get-HatPlan -Intent $intent).micro
      repo_mode = $repoMode
    }
  }

  if ($readiness -eq "Needs Refinement") {
    $response.failed_gates = @("Grounding")
    $response.missing_sources = @("At least two concrete repo references are required in repo_aware mode.")
  }

  if ($outputFormat -eq "json") {
    $response.content_json = $contentJson
  } else {
    $response.content_markdown = $markdown
  }
  return $response
}

function Invoke-ValidateArtifact {
  param([object]$Request)

  $artifactType = Get-ArtifactType -Request $Request
  $format = if (Has-Key $Request "content_format") { $Request.content_format } else { "markdown" }
  $repoMode = Get-RepoMode -Request $Request
  $intent = Get-Intent -Request $Request

  $requiredByType = @{
    "mission" = @("Problem Statement", "Desired Outcome", "Success Metrics")
    "signal" = @("Problem Statement", "Why Now/Urgency", "Desired Outcome")
    "user_story" = @("Title", "Scope", "Acceptance Criteria")
    "feature" = @("Problem Statement", "Acceptance Criteria")
    "bug" = @("Steps To Reproduce", "Expected Result", "Actual Result")
  }

  if (-not $requiredByType.ContainsKey($artifactType)) {
    $requiredByType[$artifactType] = @("Source References")
  }

  $missing = @()
  if ($format -eq "markdown") {
    $content = [string]$Request.content
    $missing = Assert-Contains -Content $content -Needles $requiredByType[$artifactType]
  } else {
    try {
      $obj = if ($Request.content -is [string]) { $Request.content | ConvertFrom-Json } else { $Request.content }
      foreach ($field in $requiredByType[$artifactType]) {
        $key = $field.ToLowerInvariant().Replace(" ", "_").Replace("/", "_")
        if (-not ((Has-Key -Obj $obj -Key $key) -or (Has-Key -Obj $obj -Key $field))) {
          $missing += $field
        }
      }
    } catch {
      $missing += "Invalid JSON content"
    }
  }

  if ($repoMode -eq "repo_aware" -and $format -eq "markdown") {
    if ([string]$Request.content -notmatch [regex]::Escape("Source References")) {
      $missing += "Source References"
    }
  }

  $valid = ($missing.Count -eq 0)
  $score = if ($valid) { 9.5 } else { [Math]::Max(0, 9.5 - ($missing.Count * 1.5)) }

  return @{
    valid = $valid
    score = $score
    missing_required_fields = $missing
    violations = @(
      if ($missing.Count -gt 0) { "Missing required fields for $artifactType validation profile." }
    ) | Where-Object { $_ -ne $null }
    warnings = @(
      if ($repoMode -eq "generic") { "Validation ran in generic mode; repo-specific checks are limited." }
      if ($intent -ne "validate") { "Validation invoked from intent '$intent'." }
    ) | Where-Object { $_ -ne $null }
    deterministic_violations = $true
    validation_profile = "strict"
    contract_version = $contractVersion
  }
}

function Invoke-ListTemplates {
  $templatesRoot = Join-Path $repoRoot "docs\templates"
  $files = Get-ChildItem $templatesRoot -Recurse -File | Where-Object { $_.Name -ne "README.md" }

  $templates = @()
  foreach ($file in $files) {
    $artifactType = switch -Regex ($file.Name) {
      "^mission\.md$" { "mission"; break }
      "^signal\.md$" { "signal"; break }
      "^epic\.md$" { "epic"; break }
      "^user-story\.md$" { "user_story"; break }
      "^bug\.md$" { "bug"; break }
      "^feature\.md$" { "feature"; break }
      "^customer-request\.md$" { "customer_request"; break }
      "^design-spec\.md$" { "design_spec"; break }
      "^research-spec\.md$" { "research_spec"; break }
      default { "unknown" }
    }
    $templates += @{
      name = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
      artifact_type = $artifactType
      path = ("docs/templates/" + $file.FullName.Substring($templatesRoot.Length + 1).Replace("\", "/"))
      template_version = $templateVersion
      status = "active"
    }
  }

  return @{
    templates = $templates
    contract_version = $contractVersion
  }
}

function Invoke-GetTemplate {
  param([object]$Request)
  $map = Get-TemplateMap
  $name = if (Has-Key $Request "name") { [string]$Request.name } else { "" }

  if (-not $map.ContainsKey($name)) {
    throw "Unknown template name: $name"
  }

  $relativePath = $map[$name]
  $fullPath = Join-Path $repoRoot $relativePath
  if (-not (Test-Path $fullPath)) {
    throw "Template file not found: $relativePath"
  }

  return @{
    name = $name
    artifact_type = $name
    template_markdown = Get-Content -Raw $fullPath
    template_version = $templateVersion
    contract_version = $contractVersion
  }
}

$request = Get-JsonRequest
$result = switch ($Tool) {
  "route_hat" { Invoke-RouteHat -Request $request }
  "create_artifact" { Invoke-CreateArtifact -Request $request }
  "validate_artifact" { Invoke-ValidateArtifact -Request $request }
  "list_templates" { Invoke-ListTemplates }
  "get_template" { Invoke-GetTemplate -Request $request }
}

$result | ConvertTo-Json -Depth 30
