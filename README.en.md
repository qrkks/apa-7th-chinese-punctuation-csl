# APA 7th edition with Chinese full-width citation parentheses

[简体中文](README.md) | English

This unofficial CSL variant preserves APA 7th edition author-date rules and
bibliography formatting while changing the parentheses generated for in-text
citations to Chinese full-width parentheses. Its companion Lua filter handles
source-authored spaces at Chinese citation boundaries.

```text
Parenthetical: （Hu & Bentler, 1999）
Multiple cites: （Dunn et al., 2014; Hu & Bentler, 1999）
Narrative: Hu & Bentler （1999）
```

The narrative form intentionally retains the APA-generated space between the
author and year parentheses. The filter preserves the source space before a
narrative citation and its internal spacing, while removing the source space
after it before continuing Chinese text. This project is not affiliated with
or endorsed by the American Psychological Association.

## Install

### Zotero only

[Open and download the CSL style](./apa-7th-chinese-punctuation.csl), then open
the file with Zotero and confirm installation. The style appears as
**APA 7th edition (Chinese full-width parentheses)**.

The Lua filter is for Pandoc/Quarto only. It is not installed with the Zotero
CSL style and does not run in Zotero.

### Quarto / Pandoc

Use both the [CSL style](./apa-7th-chinese-punctuation.csl) and the
[Chinese citation-spacing filter](./filters/zh-citation-spacing.lua). Download
them separately or clone the repository:

```powershell
git clone https://github.com/qrkks/apa-7th-chinese-punctuation-csl.git
```

Published versions are also available from
[GitHub Releases](https://github.com/qrkks/apa-7th-chinese-punctuation-csl/releases/latest).

## What changes

Only the parentheses generated for in-text citations are localized:

- parentheses change from `()` to `（）`
- the APA author/date/locator delimiter remains `, `
- the APA multiple-citation delimiter remains `; `
- the bibliography remains identical to the official APA CSL

The parentheses isolate the citation from Chinese prose, while their contents
remain an English APA author-date expression with English punctuation.
Automated tests cover parentheses, internal punctuation, narrative citations,
bibliography identity, and upstream provenance.

## Quarto configuration

Adjust the paths to the repository's location relative to the QMD project. For
example, when the two projects are sibling directories:

```yaml
csl: ../apa-7th-chinese-punctuation-csl/apa-7th-chinese-punctuation.csl
filters:
  - ../apa-7th-chinese-punctuation-csl/filters/zh-citation-spacing.lua
```

Keep the Markdown source format-neutral, including normal spaces around
citation markers:

```markdown
中文正文 [@hu1999]。
引用后还有正文 [@hu1999] 继续。
叙述式引用 @hu1999 指出……
```

Pandoc represents source spaces separately from the `Cite` node, so CSL cannot
control them. The Lua filter removes adjacent `Space` nodes on both sides of
parenthetical citations. For narrative citations, it removes only the following
source space and preserves the preceding and internal author-year spacing.
Ordinary parentheses, equations, and the bibliography are unchanged.

For an English output profile, use the standard APA CSL and omit this filter;
the QMD source does not need to change. An absolute path also works locally,
but sibling repositories and relative paths are easier to move.

## Build and update upstream

The official APA source is stored as `vendor/apa.csl`. Its version branch,
exact commit, and SHA-256 are recorded in `vendor/upstream.json`. Normal builds
use this immutable snapshot and are offline and reproducible:

```powershell
./scripts/build-style.ps1
./tests/test-style.ps1 -SkipRemoteCheck
```

To explicitly fetch a new snapshot from the stable CSL `v1.0.2` **version
branch**, record its commit and hash, and rebuild the derived style:

```powershell
./scripts/update-upstream.ps1
./tests/test-style.ps1
```

The build script changes only style metadata, the generated-file notice, and
in-text citation parentheses. It stops if the expected upstream structure has
changed. The default test confirms that the vendored file matches its recorded
exact upstream commit; use `-SkipRemoteCheck` when working offline.

## License and attribution

- [`vendor/apa.csl`](./vendor/apa.csl) and the generated
  [`apa-7th-chinese-punctuation.csl`](./apa-7th-chinese-punctuation.csl) use
  [CC BY-SA 3.0](./LICENSES/CC-BY-SA-3.0.txt).
- `filters/`, `scripts/`, `tests/`, GitHub Actions, and project documentation
  use the [MIT License](./LICENSES/MIT.txt).

Original APA CSL authors and contributors remain in the CSL metadata; `qrkks`
is listed as the maintainer of this variant. See [`LICENSE`](./LICENSE) for the
complete file-level licensing boundaries.
