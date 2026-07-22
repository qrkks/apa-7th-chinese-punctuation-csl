# Changelog

## 0.2.0 - 2026-07-22

- Replace the two order-dependent Lua filters with one `zh-citation.lua`
  pipeline that handles source spacing, citeproc, narrative year-parenthesis
  spacing, and two-author connector localization internally.
- Broaden the project documentation title to Chinese in-text citation
  adaptation while keeping the Zotero CSL name scoped to full-width
  parentheses.

## 0.1.2 - 2026-07-22

- Remove the space before the full-width year parenthesis in every narrative
  citation, including single-author, two-author, `et al.`, and corporate-author
  forms.
- Continue to preserve existing spaces around `和` and localize `&` only for
  two personal authors.

## 0.1.1 - 2026-07-22

- Localize the narrative citation author connector from `&` to `和` with a
  post-citeproc Lua filter.
- Preserve existing spaces around `和`; spacing policy remains user-controlled.
- Keep `&` unchanged in corporate author names, parenthetical citations, and
  bibliography entries.

## 0.1.0 - 2026-07-22

- Preserve the APA 7 bibliography implementation from the official CSL style.
- Localize only the outer citation parentheses: `（Author, year; Author, year）`.
- Preserve APA's English comma and semicolon delimiters inside citations.
- Add an optional Pandoc Lua filter that removes only spaces adjacent to
  parenthetical citations, allowing format-neutral Markdown source.
- Vendor the pinned official APA CSL and support reproducible offline builds.
- Make Chinese the primary project documentation and add an English README.
- Add reproducible upstream generation and Pandoc smoke tests.
- Document both parenthetical and narrative citation behavior with Chinese
  regression fixtures.
- Pin the vendored APA source to an exact upstream commit and SHA-256 hash.
- Add explicit licensing boundaries for upstream CSL content and original code.
- Add release-ready download links, generated-file guidance, and least-privilege
  CI configuration.
