---
title: About — Docklands
description: How Docklands combines Gleam, Markdown, Tailwind CSS, and isolated interactive islands.
published: 2026-09-30
---

<p class='eyebrow'>Project map</p>

# One website. A few clear responsibilities.

Docklands is a reference project rather than a generalized static-site framework. Its structure is deliberately direct enough to inspect without first learning an internal platform.

<div class='architecture-map'>
  <div><span>01</span><strong>content/routes/</strong><small>Standalone Markdown pages</small></div>
  <div><span>02</span><strong>content/collections/</strong><small>Repeatable dated content</small></div>
  <div><span>03</span><strong>src/</strong><small>Gleam layout and generation</small></div>
  <div><span>04</span><strong>assets/</strong><small>Styles, images, and brand files</small></div>
  <div><span>05</span><strong>widgets/</strong><small>Optional browser islands</small></div>
  <div><span>06</span><strong>dist/</strong><small>Ordinary deployable output</small></div>
</div>

---

## The useful boundaries

Markdown owns prose. Raw HTML handles the occasional layout that Markdown cannot express clearly. Gleam owns repeated structure and file generation. Tailwind compiles the static stylesheet. Interactive code is reserved for independent regions with explicit boundaries.

The included build-receipt island uses Lustre because it is the author's preferred tool when a widget benefits from Model, Msg, update, and view. That is a demo choice, not a Docklands requirement. A site can use plain JavaScript or another suitable library without changing the static-first architecture.

Nothing hydrates the whole page. Nothing intercepts navigation. The output can be served by any static host.

<aside class='content-note'>
  <strong>This is intentionally one project.</strong>
  Docklands should acquire abstractions only after repeated website needs make them obvious.
</aside>

## What the build also handles

- Page titles and descriptions from frontmatter
- Canonical and social metadata
- Multiple collections with featured artwork
- Per-page, per-item, and per-collection indexing controls
- Sitemap, robots file, and custom 404 page
- Favicon fallbacks and image optimization

<div class='closing-link'>
  <span>Ready to trace the complete build?</span>
  <a href='/guides/first-site/'>Open the first guide →</a>
</div>
