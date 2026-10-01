---
title: Add routes and page metadata
description: Create standalone pages, understand directory-based URLs, and control metadata and indexing.
published: 2026-09-28
---

# Add routes and page metadata

A Markdown file beneath `content/routes/` becomes one HTML file beneath `dist/`. The directory structure is the routing configuration.

## Choose the URL with folders

`content/routes/index.md` becomes `/`. `content/routes/about/index.md` becomes `/about/`. `content/routes/uses/index.md` becomes `/uses/`. There is no separate router table and no client-side router.

## Supply the required metadata

Every route begins with a title and description:

```yaml
---
title: Uses — My site
description: The tools and techniques behind this website.
---
```

The shared layout uses these values for the document title, description, canonical URL, Open Graph metadata, and X card metadata.

## Keep a page out of search

Add `noindex: true` when a page should exist publicly but should not appear in search engines or the sitemap. Docklands always applies this treatment to the generated 404 page.

## Use Markdown until HTML is clearer

Headings, prose, lists, links, and code normally belong in Markdown. Raw HTML is allowed when you need a deliberate section layout or classes for a designed block. Both approaches pass through the same shared page layout.
