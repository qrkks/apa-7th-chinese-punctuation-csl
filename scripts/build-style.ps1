param(
  [string]$UpstreamPath = (
    Join-Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'vendor') 'apa.csl'
  ),
  [string]$OutputPath = (
    Join-Path (Split-Path -Parent $PSScriptRoot) 'apa-7th-chinese-punctuation.csl'
  )
)

$ErrorActionPreference = 'Stop'
$openParen = [char]0xFF08
$closeParen = [char]0xFF09

function Replace-ExactlyOnce {
  param(
    [Parameter(Mandatory)] [string]$Text,
    [Parameter(Mandatory)] [string]$Pattern,
    [Parameter(Mandatory)] [string]$Replacement,
    [Parameter(Mandatory)] [string]$Label
  )

  $regex = [regex]::new($Pattern)
  $matches = $regex.Matches($Text)
  if ($matches.Count -ne 1) {
    throw "Expected exactly one $Label match, found $($matches.Count). Upstream APA CSL may have changed."
  }
  $regex.Replace(
    $Text,
    [System.Text.RegularExpressions.MatchEvaluator]{
      param($match)
      $Replacement
    },
    1
  )
}

$upstreamFullPath = [IO.Path]::GetFullPath($UpstreamPath)
if (-not (Test-Path -LiteralPath $upstreamFullPath)) {
  throw "Vendored upstream APA CSL is missing: $upstreamFullPath"
}
$content = [IO.File]::ReadAllText($upstreamFullPath, [Text.Encoding]::UTF8) -replace "`r`n", "`n"

$content = Replace-ExactlyOnce $content '<title>APA Style 7th edition</title>' `
  '<title>APA 7th edition (Chinese full-width parentheses)</title>' 'style title'
$content = Replace-ExactlyOnce $content '<title-short>.*?</title-short>' `
  '<title-short>APA 7 with Chinese full-width citation parentheses</title-short>' 'short title'
$content = Replace-ExactlyOnce $content '<id>https?://www\.zotero\.org/styles/apa</id>' `
  '<id>https://github.com/qrkks/apa-7th-chinese-punctuation-csl</id>' 'style ID'
$content = Replace-ExactlyOnce $content '<link href="https?://www\.zotero\.org/styles/apa" rel="self"/>' `
  '<link href="https://raw.githubusercontent.com/qrkks/apa-7th-chinese-punctuation-csl/main/apa-7th-chinese-punctuation.csl" rel="self"/>' 'self link'
$content = Replace-ExactlyOnce $content '<link href="https?://www\.zotero\.org/styles/apa-6th-edition" rel="template"/>' `
  '<link href="http://www.zotero.org/styles/apa" rel="template"/>' 'template link'
$content = Replace-ExactlyOnce $content '<summary>.*?</summary>' `
  '<summary>APA 7th edition with full-width parentheses around in-text citations.</summary>' 'summary'

$authorBoundary = '    </author>\n    <category citation-format="author-date"/>'
$contributorBlock = @'
    </author>
    <contributor>
      <name>qrkks</name>
      <uri>https://github.com/qrkks</uri>
    </contributor>
    <category citation-format="author-date"/>
'@
$content = Replace-ExactlyOnce $content $authorBoundary $contributorBlock 'contributor insertion point'

$localizedLayout = '<layout delimiter="; " prefix="' +
  $openParen + '" suffix="' + $closeParen + '">'
$content = Replace-ExactlyOnce $content '<layout delimiter="; " prefix="\(" suffix="\)">' `
  $localizedLayout 'citation parentheses'

$outputFullPath = [IO.Path]::GetFullPath($OutputPath)
$outputDirectory = Split-Path -Parent $outputFullPath
if (-not (Test-Path -LiteralPath $outputDirectory)) {
  New-Item -ItemType Directory -Path $outputDirectory | Out-Null
}
[IO.File]::WriteAllText($outputFullPath, $content, [Text.UTF8Encoding]::new($false))
Write-Output "Generated $outputFullPath from $upstreamFullPath"
