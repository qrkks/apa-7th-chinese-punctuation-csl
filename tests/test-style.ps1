param(
  [string]$Pandoc = 'pandoc',
  [switch]$SkipRemoteCheck
)

$ErrorActionPreference = 'Stop'
$openParen = [char]0xFF08
$closeParen = [char]0xFF09
$projectRoot = Split-Path -Parent $PSScriptRoot
$stylePath = Join-Path $projectRoot 'apa-7th-chinese-punctuation.csl'
$vendorPath = Join-Path (Join-Path $projectRoot 'vendor') 'apa.csl'
$fixturesPath = Join-Path $PSScriptRoot 'fixtures'
$fixturePath = Join-Path $fixturesPath 'citations.md'
$bibliographyPath = Join-Path $fixturesPath 'references.bib'
$filterPath = Join-Path (Join-Path $projectRoot 'filters') 'zh-citation-spacing.lua'

if (-not (Test-Path -LiteralPath $stylePath)) {
  throw "Generated style is missing: $stylePath"
}
if (-not (Test-Path -LiteralPath $vendorPath)) {
  throw "Vendored upstream style is missing: $vendorPath"
}

$styleText = [IO.File]::ReadAllText($stylePath, [Text.Encoding]::UTF8)
[xml]$style = $styleText
$ns = [Xml.XmlNamespaceManager]::new($style.NameTable)
$ns.AddNamespace('csl', 'http://purl.org/net/xbiblio/csl')

$layout = $style.SelectSingleNode('/csl:style/csl:citation/csl:layout', $ns)
if ($null -eq $layout) {
  throw 'Citation layout is missing.'
}
if ($layout.GetAttribute('prefix') -ne $openParen -or
    $layout.GetAttribute('suffix') -ne $closeParen -or
    $layout.GetAttribute('delimiter') -ne '; ') {
  throw 'Citation layout does not use full-width outer parentheses with the APA delimiter.'
}
$citationGroup = $layout.SelectSingleNode('./csl:group[1]', $ns)
if ($citationGroup.GetAttribute('delimiter') -ne ', ') {
  throw 'Citation author/date/locator delimiter differs from APA.'
}

$title = $style.SelectSingleNode('/csl:style/csl:info/csl:title', $ns).InnerText
$id = $style.SelectSingleNode('/csl:style/csl:info/csl:id', $ns).InnerText
$license = $style.SelectSingleNode('/csl:style/csl:info/csl:rights', $ns).GetAttribute('license')
if ($title -ne 'APA 7th edition (Chinese full-width parentheses)') { throw 'Unexpected style title.' }
if ($id -ne 'https://github.com/qrkks/apa-7th-chinese-punctuation-csl') { throw 'Unexpected style ID.' }
if ($license -ne 'http://creativecommons.org/licenses/by-sa/3.0/') { throw 'Upstream CC BY-SA license was not preserved.' }

$vendorText = [IO.File]::ReadAllText($vendorPath, [Text.Encoding]::UTF8)
[xml]$upstream = $vendorText
$upstreamNs = [Xml.XmlNamespaceManager]::new($upstream.NameTable)
$upstreamNs.AddNamespace('csl', 'http://purl.org/net/xbiblio/csl')
$bibliography = $style.SelectSingleNode('/csl:style/csl:bibliography', $ns)
$upstreamBibliography = $upstream.SelectSingleNode('/csl:style/csl:bibliography', $upstreamNs)
if ($bibliography.OuterXml -ne $upstreamBibliography.OuterXml) {
  throw 'Bibliography section differs from the vendored APA CSL.'
}

if (-not $SkipRemoteCheck) {
  $upstreamUrl = 'https://raw.githubusercontent.com/citation-style-language/styles/v1.0.2/apa.csl'
  $remoteText = (Invoke-WebRequest -Uri $upstreamUrl -UseBasicParsing).Content
  if (($vendorText -replace "`r`n", "`n") -ne ($remoteText -replace "`r`n", "`n")) {
    throw 'Vendored APA CSL differs from the pinned official upstream file.'
  }
}

$rendered = & $Pandoc $fixturePath --citeproc `
  "--bibliography=$bibliographyPath" "--csl=$stylePath" `
  "--lua-filter=$filterPath" -t plain
if ($LASTEXITCODE -ne 0) {
  throw "Pandoc smoke test failed with exit code $LASTEXITCODE."
}
$renderedText = $rendered -join "`n"

$expected = @(
  ('Single citation' + $openParen + 'Hu & Bentler, 1999' + $closeParen + '.'),
  ('Multiple citations' + $openParen + 'Dunn et al., 2014; Hu & Bentler, 1999' + $closeParen + '.'),
  ('Narrative citation Hu & Bentler ' + $openParen + '1999' + $closeParen + '.'),
  ('Citation with following text' + $openParen + 'Hu & Bentler, 1999' + $closeParen + 'continues.')
)
foreach ($value in $expected) {
  if (-not $renderedText.Contains($value)) {
    throw "Pandoc output is missing expected citation: $value`n$renderedText"
  }
}

Write-Output 'All CSL tests passed.'
