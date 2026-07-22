param(
  [string]$UpstreamRef = 'v1.0.2',
  [string]$UpstreamPath = (
    Join-Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'vendor') 'apa.csl'
  ),
  [string]$MetadataPath = (
    Join-Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'vendor') 'upstream.json'
  ),
  [string]$OutputPath = (
    Join-Path (Split-Path -Parent $PSScriptRoot) 'apa-7th-chinese-punctuation.csl'
  )
)

$ErrorActionPreference = 'Stop'

$repository = 'citation-style-language/styles'
$headers = @{ 'User-Agent' = 'apa-7th-chinese-punctuation-csl-updater' }
$commitsUrl = "https://api.github.com/repos/$repository/commits?path=apa.csl&sha=$UpstreamRef&per_page=1"
$commits = Invoke-RestMethod -Uri $commitsUrl -Headers $headers
if ($commits.Count -ne 1 -or $commits[0].sha -notmatch '^[0-9a-f]{40}$') {
  throw "Could not resolve apa.csl on upstream version branch $UpstreamRef to a commit."
}
$upstreamCommit = $commits[0].sha
$upstreamUrl = "https://raw.githubusercontent.com/$repository/$upstreamCommit/apa.csl"
$content = (Invoke-WebRequest -Uri $upstreamUrl -UseBasicParsing).Content -replace "`r`n", "`n"
$upstreamFullPath = [IO.Path]::GetFullPath($UpstreamPath)
$upstreamDirectory = Split-Path -Parent $upstreamFullPath
if (-not (Test-Path -LiteralPath $upstreamDirectory)) {
  New-Item -ItemType Directory -Path $upstreamDirectory | Out-Null
}
[IO.File]::WriteAllText($upstreamFullPath, $content, [Text.UTF8Encoding]::new($false))
$sha256 = (Get-FileHash -LiteralPath $upstreamFullPath -Algorithm SHA256).Hash.ToLowerInvariant()

$metadataFullPath = [IO.Path]::GetFullPath($MetadataPath)
$metadataDirectory = Split-Path -Parent $metadataFullPath
if (-not (Test-Path -LiteralPath $metadataDirectory)) {
  New-Item -ItemType Directory -Path $metadataDirectory | Out-Null
}
$metadataJson = @"
{
  "repository": "$repository",
  "version_branch": "$UpstreamRef",
  "commit": "$upstreamCommit",
  "path": "apa.csl",
  "sha256": "$sha256"
}
"@
[IO.File]::WriteAllText($metadataFullPath, $metadataJson.TrimEnd() + "`n", [Text.UTF8Encoding]::new($false))
Write-Output "Updated $upstreamFullPath from $UpstreamRef at commit $upstreamCommit"
Write-Output "Recorded upstream provenance in $metadataFullPath"

& (Join-Path $PSScriptRoot 'build-style.ps1') `
  -UpstreamPath $upstreamFullPath -OutputPath $OutputPath
