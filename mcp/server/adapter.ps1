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

function Get-ConstraintClassification {
  param([string]$Intent)
  switch ($Intent) {
    "clarify" { return "ambiguity" }
    "plan" { return "execution_planning" }
    "de-risk" { return "risk_nfr" }
    "decide" { return "option_conflict" }
    "validate" { return "quality_gate_check" }
    "recover" { return "delivery_drift" }
    default { return "ambiguity" }
  }
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
        primary = "product_owner"
        secondary = @("researcher", "designer")
        micro = @("craft.frame_outcome", "craft.bound_scope", "craft.write_acceptance")
      }
    }
    "plan" {
      return @{
        primary = "product_owner"
        secondary = @("engineer", "researcher")
        micro = @("craft.slice_vertical", "engineer.map_system", "craft.validate_readiness")
      }
    }
    "de-risk" {
      return @{
        primary = "engineer"
        secondary = @("researcher", "designer", "entrepreneur")
        micro = @("engineer.model_constraints", "engineer.map_failures", "research.define_evidence_gate")
      }
    }
    "decide" {
      return @{
        primary = "meta"
        secondary = @("entrepreneur", "product_owner", "engineer")
        micro = @("human.narrate_decision", "entrepreneur.articulate_opportunity_cost", "human.leave_receipt")
      }
    }
    "validate" {
      return @{
        primary = "product_owner"
        secondary = @("engineer", "designer")
        micro = @("craft.validate_readiness", "engineer.define_eng_done", "design.map_experience_states")
      }
    }
    "recover" {
      return @{
        primary = "meta"
        secondary = @("product_owner", "engineer", "marketer")
        micro = @("human.detect_drift", "human.enforce_transition", "market.monitor_post_launch_signal")
      }
    }
    default {
      return @{
        primary = "product_owner"
        secondary = @("researcher")
        micro = @("craft.frame_outcome")
      }
    }
  }
}

function Normalize-SourceRefs {
  param([object[]]$Refs)
  $normalized = @()
  foreach ($ref in @($Refs)) {
    if ($null -eq $ref) { continue }
    if ($ref -is [string]) {
      if (-not [string]::IsNullOrWhiteSpace($ref)) {
        $normalized += @{
          source = $ref
          uri = $ref
          evidence_type = "other"
          confidence = "medium"
        }
      }
      continue
    }
    if ($ref.PSObject.Properties.Name -contains "source" -and $ref.PSObject.Properties.Name -contains "uri") {
      $normalized += @{
        source = [string]$ref.source
        uri = [string]$ref.uri
        locator = (Coalesce-String -Value $ref.locator -Fallback "")
        evidence_type = (Coalesce-String -Value $ref.evidence_type -Fallback "other")
        confidence = (Coalesce-String -Value $ref.confidence -Fallback "medium")
      }
    }
  }
  return $normalized
}

function Test-StructuredCitations {
  param([object[]]$Refs)
  $items = @($Refs)
  if ($items.Count -lt 2) { return $false }
  foreach ($ref in $items) {
    if ($null -eq $ref) { return $false }
    if ($ref -is [string]) { return $false }
    if (-not ($ref.PSObject.Properties.Name -contains "source")) { return $false }
    if (-not ($ref.PSObject.Properties.Name -contains "uri")) { return $false }
    if ([string]::IsNullOrWhiteSpace([string]$ref.source)) { return $false }
    if ([string]::IsNullOrWhiteSpace([string]$ref.uri)) { return $false }
  }
  return $true
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
  $constraint = Get-ConstraintClassification -Intent $intent

  $requestText = Coalesce-String -Value $Request.request_text -Fallback ""
  $sourceText = "{0}|{1}|{2}|{3}" -f $requestText, $intent, $artifactType, $repoMode
  $sig = Get-DeterministicSignature -Value $sourceText

  return @{
    primary_hat = $plan.primary
    secondary_hats = $plan.secondary
    constraint_classification = $constraint
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
    reasoning_trace = @{
      intent_inference = "Intent selected using explicit input when present, else deterministic keyword rules."
      constraint_classification = $constraint
      hat_selection_rationale = "Primary and secondary hats selected from routing table for '$intent'."
      decision_points = @(
        "Determine intent",
        "Determine repo mode",
        "Select primary hat",
        "Select secondary hats"
      )
      tradeoffs_considered = @(
        "specificity_vs_speed",
        "strictness_vs_flexibility"
      )
      final_merge_rationale = "Return request-scoped route with deterministic signature and guardrails."
    }
    request_id = [guid]::NewGuid().ToString()
    trace_id = [guid]::NewGuid().ToString()
    created_at = [DateTime]::UtcNow.ToString("o")
    schema_version = "1.1"
    tool_version = "adapter-1.1"
    contract_version = $contractVersion
  }
}

function Invoke-CreateArtifact {
  param([object]$Request)
  $intent = Get-Intent -Request $Request
  $repoMode = Get-RepoMode -Request $Request
  $artifactType = Get-ArtifactType -Request $Request
  $outputFormat = if (Has-Key $Request "output_format") { $Request.output_format } else { "markdown" }
  $constraint = Get-ConstraintClassification -Intent $intent
  $sourceRefs = @()
  if (Has-Key $Request "source_references" -and $Request.source_references -ne $null) {
    $sourceRefs = @($Request.source_references)
  }
  $normalizedRefs = @(Normalize-SourceRefs -Refs $sourceRefs)
  $hasStrictCitations = Test-StructuredCitations -Refs $sourceRefs

  $failedGates = @()
  if ($repoMode -eq "repo_aware" -and $normalizedRefs.Count -lt 2) {
    $failedGates += "Grounding"
  }
  if ($repoMode -eq "repo_aware" -and -not $hasStrictCitations) {
    $failedGates += "Citation Format"
  }

  $groundingStatus = if ($repoMode -eq "repo_aware" -and $failedGates.Count -gt 0) { "insufficient" } elseif ($normalizedRefs.Count -ge 2) { "grounded" } else { "partial" }
  $readiness = if ($failedGates.Count -gt 0) { "Needs Refinement" } else { "Ready" }
  $plan = Get-HatPlan -Intent $intent
  $primaryHat = $plan.primary
  $secondaryHat = ($plan.secondary | Select-Object -First 1)

  $requestText = Coalesce-String -Value $Request.request_text -Fallback "Generated artifact content."
  $markdown = @"
# $artifactType

## Description
$requestText

## Source References
$(
  if ($normalizedRefs.Count -gt 0) { ($normalizedRefs | ForEach-Object { "- $($_.source)" }) -join "`n" } else { "- Unknown - needs discovery" }
)
"@

  $contentJson = @{
    artifact_type = $artifactType
    intent = $intent
    summary = (Coalesce-String -Value $Request.request_text -Fallback "")
    source_references = $normalizedRefs
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
      micro_steps = $plan.micro
      repo_mode = $repoMode
      required_outputs = @(
        "readiness_verdict",
        "source_citations",
        "reasoning_trace",
        "acceptance_scope"
      )
      contribution_summary = @(
        @{
          hat = $primaryHat
          added = "Primary artifact framing and readiness verdict."
        },
        @{
          hat = $secondaryHat
          added = "Constraint coverage and risk shaping for artifact quality."
        }
      )
      unresolved_risks = @(
        if ($failedGates.Count -gt 0) {
          "Repo-aware citation requirements are not fully satisfied."
        }
      ) | Where-Object { $_ -ne $null }
      receipt = @{
        status = if ($readiness -eq "Ready") { "complete" } else { "partial" }
        summary = if ($readiness -eq "Ready") { "All required collaboration outputs were produced." } else { "Artifact generated with remaining citation/grounding gaps." }
      }
    }
    source_citations = $normalizedRefs
    assumptions = @("Routing and validation profiles follow default v1.1 policies.")
    open_questions = @(
      if ($repoMode -eq "repo_aware" -and $normalizedRefs.Count -lt 2) {
        "Can you provide at least two concrete repo references?"
      }
      if ($repoMode -eq "repo_aware" -and -not $hasStrictCitations) {
        "Can you provide references as structured citation objects (source + uri)?"
      }
    ) | Where-Object { $_ -ne $null }
    next_best_action = if ($readiness -eq "Ready") { "Proceed to implementation planning." } else { "Provide missing repo references and rerun artifact generation." }
    score = if ($readiness -eq "Ready") { 9.0 } else { 6.5 }
    reasoning_trace = @{
      intent_inference = "Create-artifact invoked with deterministic intent selection."
      constraint_classification = $constraint
      hat_selection_rationale = "Artifact generation follows intent-first hat plan."
      handoff_sequence = @(
        @{
          from_hat = $primaryHat
          to_hat = $secondaryHat
          reason = "Secondary constraint coverage."
        }
      )
      decision_points = @("evaluate_grounding", "set_readiness_verdict", "render_output_format")
      tradeoffs_considered = @("speed_vs_grounding_depth", "strictness_vs_progress")
      final_merge_rationale = "Return one request-scoped artifact with readiness and source evidence."
    }
    request_id = [guid]::NewGuid().ToString()
    trace_id = [guid]::NewGuid().ToString()
    created_at = [DateTime]::UtcNow.ToString("o")
    schema_version = "1.1"
    tool_version = "adapter-1.1"
  }

  if ($failedGates.Count -gt 0) {
    $response.failed_gates = $failedGates
    $response.missing_sources = @(
      if ($repoMode -eq "repo_aware" -and $normalizedRefs.Count -lt 2) {
        "At least two concrete repo references are required in repo_aware mode."
      }
      if ($repoMode -eq "repo_aware" -and -not $hasStrictCitations) {
        "Repo-aware mode requires structured citation objects with source and uri."
      }
    ) | Where-Object { $_ -ne $null }
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
    score_breakdown = @{
      structure_compliance = if ($valid) { 9.5 } else { 7.0 }
      repo_grounding_and_citations = if ($repoMode -eq "repo_aware" -and $missing.Count -gt 0) { 6.0 } else { 9.0 }
      acceptance_criteria_testability = if ($missing.Count -gt 0) { 7.0 } else { 9.0 }
      clarity_and_esl_readability = 9.0
    }
    missing_required_fields = $missing
    findings = @(
      foreach ($field in $missing) {
        @{
          code = "MISSING_REQUIRED_FIELD"
          severity = "error"
          field_path = "/content"
          message = "Missing required field: $field"
          remediation = "Add '$field' to artifact content and rerun validation."
        }
      }
    )
    violations = @(
      if ($missing.Count -gt 0) { "Missing required fields for $artifactType validation profile." }
    ) | Where-Object { $_ -ne $null }
    warnings = @(
      if ($repoMode -eq "generic") { "Validation ran in generic mode; repo-specific checks are limited." }
      if ($intent -ne "validate") { "Validation invoked from intent '$intent'." }
    ) | Where-Object { $_ -ne $null }
    deterministic_violations = $true
    validation_profile = "strict"
    request_id = [guid]::NewGuid().ToString()
    trace_id = [guid]::NewGuid().ToString()
    created_at = [DateTime]::UtcNow.ToString("o")
    schema_version = "1.1"
    tool_version = "adapter-1.1"
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
