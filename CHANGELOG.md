# Changelog

Notable Docklands changes are recorded here.

## Unreleased

No changes yet.

## 2.0.1 — 2026-10-07

- Clarified that Lustre is the included demo's preferred stateful-island implementation, not a requirement for Docklands sites.
- Documented plain JavaScript and other focused browser libraries as valid island choices.
- Linked the project-neutral island decision guide from The Markdown Works.

## 2.0.0 — 2026-10-06

- Added support for Markdown content contract 1.0.0 using real YAML mapping semantics.
- Required and validated `title`, `description`, and `published` on routes and collection items.
- Added the unchanged shared portability example and dated route sitemap entries.

## 1.0.0 — 2026-10-05

- Established the documented pre-contract Docklands baseline at commit `1882ef97dbc787efc26ea8c6616e8aa5552fc2a6`.

## Release policy

Docklands uses semantic versioning. Its project version is independent from the Markdown content contract version it supports. Every release receives an annotated `vX.Y.Z` Git tag pointing to the checked release commit; changes intended for a later release remain under **Unreleased** until that release is prepared.
