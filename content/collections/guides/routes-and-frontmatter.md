---
title: Add routes and page metadata
description: Create standalone pages, understand directory-based URLs, and control metadata and indexing.
published: 2026-09-28
tags: Routes, Frontmatter, Metadata
featured_image: /assets/images/guide-routes.svg
featured_alt: A teal route map branching from one path into three pages
---

# Add routes and page metadata

{{ featured-image }}

A Markdown file beneath `content/routes/` becomes one HTML file beneath `dist/`. The directory structure is the routing configuration.

## Choose the URL with folders

`content/routes/index.md` becomes `/`. `content/routes/about/index.md` becomes `/about/`. `content/routes/uses/index.md` becomes `/uses/`. There is no separate router table and no client-side router.

## Supply the required metadata

Every route begins with a title, description, and original publication date:

```yaml
---
title: Uses — My site
description: The tools and techniques behind this website.
published: 2026-10-06
---
```

The shared layout uses the title and description for document and social metadata. The publication date must be a real `YYYY-MM-DD` calendar date. It is included in the sitemap for a route but is not automatically shown on the page.

These three non-empty, top-level fields form Docklands' portable content baseline. Quoted and plain YAML strings are both decoded normally. You may add project-specific scalar, list, or mapping fields without confusing the core-field reader; unknown metadata is ignored.

## Keep a page out of search

Add `noindex: true` when a page should exist publicly but should not appear in search engines or the sitemap. Docklands always applies this treatment to the generated 404 page.

## Use Markdown until HTML is clearer

Headings, prose, lists, links, and code normally belong in Markdown. Raw HTML is allowed when you need a deliberate section layout or classes for a designed block. Both approaches pass through the same shared page layout.
