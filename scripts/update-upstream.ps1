param(
  [string]$UpstreamRef = 'v1.0.2',
  [string]$UpstreamPath = (
    Join-Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'vendor') 'apa.csl'
  ),
  [string]$OutputPath = (
    Join-Path (Split-Path -Parent $PSScriptRoot) 'apa-7th-chinese-punctuation.csl'
  )
)

$ErrorActionPreference = 'Stop'

$upstreamUrl = "https://raw.githubusercontent.com/citation-style-language/styles/$UpstreamRef/apa.csl"
$content = (Invoke-WebRequest -Uri $upstreamUrl -UseBasicParsing).Content -replace "`r`n", "`n"
$upstreamFullPath = [IO.Path]::GetFullPath($UpstreamPath)
$upstreamDirectory = Split-Path -Parent $upstreamFullPath
if (-not (Test-Path -LiteralPath $upstreamDirectory)) {
  New-Item -ItemType Directory -Path $upstreamDirectory | Out-Null
}
[IO.File]::WriteAllText($upstreamFullPath, $content, [Text.UTF8Encoding]::new($false))
Write-Output "Updated $upstreamFullPath from $upstreamUrl"

& (Join-Path $PSScriptRoot 'build-style.ps1') `
  -UpstreamPath $upstreamFullPath -OutputPath $OutputPath
