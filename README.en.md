# APA 7th edition with Chinese full-width citation parentheses

[简体中文](README.md) | English

An unofficial CSL variant that keeps the APA 7th edition bibliography and
author rules while using full-width outer parentheses for in-text citations in
Simplified Chinese prose.

```text
（Hu & Bentler, 1999）
（Dunn et al., 2014; Hu & Bentler, 1999）
```

This project is not affiliated with or endorsed by the American Psychological
Association.

## Install

Download `apa-7th-chinese-punctuation.csl`, or clone the repository to keep the
CSL and Pandoc filter together:

```powershell
git clone https://github.com/qrkks/apa-7th-chinese-punctuation-csl.git
```

## What changes

Only the outer parentheses of in-text citations are localized:

- parentheses: `()` to `（）`
- author/date/locator delimiter remains APA `, `
- multiple-citation delimiter remains APA `; `

The citation content is an English APA author-date expression isolated by the
parentheses, so its internal punctuation remains English. The bibliography
section is kept identical to the upstream APA CSL. Automated tests enforce this
invariant.

## Quarto

Use the CSL together with the citation-spacing Lua filter, with paths adjusted
to where this repository is stored relative to the QMD project:

```yaml
csl: ../apa-7th-chinese-punctuation-csl/apa-7th-chinese-punctuation.csl
filters:
  - ../apa-7th-chinese-punctuation-csl/filters/zh-citation-spacing.lua
```

Keep the Markdown source format-neutral, including its normal space before a
citation marker:

```markdown
中文正文 [@hu1999]。
```

Pandoc represents that source space separately from the `Cite` node, so CSL
cannot control it. The Lua filter removes only `Space` nodes immediately before
or after parenthetical citations. Narrative citations, ordinary parentheses,
equations, and the bibliography are unchanged.

For an English output profile, use the standard APA CSL and omit this filter;
the QMD source does not need to change. An absolute path also works locally,
but a relative path is easier to move when the document project and this
repository are stored as sibling directories.

## Zotero

Open `apa-7th-chinese-punctuation.csl` with Zotero and confirm installation.
The style appears as **APA 7th edition (Chinese full-width parentheses)**.

## Update from upstream APA

The pinned official APA source is committed as `vendor/apa.csl`. Normal builds
are offline and reproducible:

```powershell
./scripts/build-style.ps1
./tests/test-style.ps1 -SkipRemoteCheck
```

To explicitly refresh the vendored source from the pinned official CSL tag and
then rebuild the derived style:

```powershell
./scripts/update-upstream.ps1
./tests/test-style.ps1
```

The update script downloads the official APA CSL from the stable CSL 1.0.2 tag.
The build script changes the style metadata and outer citation parentheses
only, and stops if the expected upstream structure changes. The default test
also confirms that the vendored snapshot matches that pinned upstream; use
`-SkipRemoteCheck` when working offline.

## License and attribution

The generated style is derived from the official APA CSL and remains licensed
under CC BY-SA 3.0. Original authors and contributors remain in the CSL
metadata; `qrkks` is listed as the maintainer of this variant.
