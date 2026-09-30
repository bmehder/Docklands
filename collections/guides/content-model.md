---
title: Shape content without inventing a CMS
description: Use routes, collections, frontmatter, and explicit components as a compact content model.
published: 2026-09-27
featured_image: /assets/images/guide-content.svg
featured_alt: An abstract dark document with teal and amber content lines
---

# Shape content without inventing a CMS

{{ featured-image }}

A content model does not need an administration panel to be useful. Docklands uses a few filesystem conventions that remain visible to writers and developers alike.

## Routes are singular

A route is a standalone page with its own URL. About pages, landing pages, and collection indexes fit naturally here.

## Collections repeat

A collection describes content that shares fields and presentation. Each definition names its source directory, public route, listing placeholder, singular label, and indexing policy.

Every entry currently carries:

- A title and description
- A publication date
- Featured artwork and alternative text
- Optional `noindex` frontmatter
- A Markdown body

## Components stay explicit

Placeholders such as `{{ featured-image }}` are replaced by Gleam functions before Markdown is rendered. This is deliberately less powerful than a general template language—and easier to trace.
