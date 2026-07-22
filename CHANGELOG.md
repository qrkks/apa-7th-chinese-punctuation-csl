# Changelog

## Unreleased

- Preserve the APA 7 bibliography implementation from the official CSL style.
- Localize only the outer citation parentheses: `（Author, year; Author, year）`.
- Preserve APA's English comma and semicolon delimiters inside citations.
- Add an optional Pandoc Lua filter that removes only spaces adjacent to
  parenthetical citations, allowing format-neutral Markdown source.
- Vendor the pinned official APA CSL and support reproducible offline builds.
- Add reproducible upstream generation and Pandoc smoke tests.
