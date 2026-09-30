---
title: About — Docklands
description: How Docklands combines Gleam, Markdown, Tailwind CSS, and isolated Lustre islands.
---

<p class='eyebrow'>Project map</p>

# One website. A few clear responsibilities.

Docklands is a reference project rather than a generalized static-site framework. Its structure is deliberately direct enough to inspect without first learning an internal platform.

<div class='architecture-map'>
  <div><span>01</span><strong>routes/</strong><small>Standalone Markdown pages</small></div>
  <div><span>02</span><strong>collections/</strong><small>Repeatable dated content</small></div>
  <div><span>03</span><strong>src/</strong><small>Gleam layout and generation</small></div>
  <div><span>04</span><strong>assets/</strong><small>Styles, images, and brand files</small></div>
  <div><span>05</span><strong>widgets/</strong><small>Optional Lustre islands</small></div>
  <div><span>06</span><strong>dist/</strong><small>Ordinary deployable output</small></div>
</div>

---

## The useful boundaries

Markdown owns prose. Raw HTML handles the occasional layout that Markdown cannot express clearly. Gleam owns repeated structure and file generation. Tailwind compiles the static stylesheet. Lustre is reserved for independent interactive regions.

Nothing hydrates the whole page. Nothing intercepts navigation. The output can be served by any static host.

<aside class='content-note'>
  <strong>This is intentionally one project.</strong>
  Docklands should acquire abstractions only after repeated website needs make them obvious.
</aside>

## What the build also handles

- Page titles and descriptions from frontmatter
- Canonical and social metadata
- Multiple collections with featured artwork
- Per-page, per-entry, and per-collection indexing controls
- Sitemap, robots file, and custom 404 page
- Favicon fallbacks and image optimization

<div class='closing-link'>
  <span>Ready to trace the complete build?</span>
  <a href='/guides/first-site/'>Open the first guide →</a>
</div>
