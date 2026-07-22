# Changelog

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
