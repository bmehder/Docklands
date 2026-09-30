<p align="center">
  <img src="assets/static/docklands-mark.svg" width="72" height="72" alt="Docklands logo">
</p>

# Docklands

A small, content-first static-site starter built with Gleam, Markdown, Tailwind CSS, and optional Lustre islands.

**Live site:** [docklands-ssg.vercel.app](https://docklands-ssg.vercel.app)

Docklands is a reference project rather than a generalized framework. It demonstrates how to build a complete content-led website while keeping the source and generated output easy to understand.

## Philosophy

- Write pages and entries primarily in Markdown.
- Use raw HTML when a section genuinely needs more structure.
- Keep shared layout and generation logic in small Gleam functions.
- Generate one static Tailwind stylesheet.
- Add plain JavaScript or an isolated Lustre island only where useful.
- Produce ordinary HTML, CSS, SVG, WebP, PNG, and page-specific JavaScript.

There is no client-side router, site-wide hydration, or application shell.

## Quick start

You will need Gleam, Erlang/OTP, Node.js, and npm.

```sh
npm install
npm run build
npm run serve
```

Open [http://localhost:8000](http://localhost:8000). Python's basic server does not automatically use the custom error page, so preview it directly at `/404.html`.

## Project structure

```text
.
├── assets/
│   ├── css/site.css             # Tailwind source and site styles
│   ├── default/favicon.svg      # Neutral fallback icon
│   └── static/                  # Copied assets and image sources
├── collections/
│   ├── guides/                  # Practical documentation entries
│   └── notes/                   # Short architectural notes
├── routes/                      # Markdown tree mirrored into dist/
│   ├── index.md
│   ├── 404.md
│   ├── about/index.md
│   ├── guides/index.md
│   └── notes/index.md
├── scripts/optimize-images.mjs
├── src/
│   ├── collections.gleam        # Collection definitions and entry type
│   ├── components.gleam         # Reusable static HTML blocks
│   ├── docklands.gleam          # Markdown rendering and file generation
│   └── site.gleam               # Shared document layout and navigation
├── widgets/
│   └── src/build_receipt.gleam  # Isolated Lustre build-receipt island
└── dist/                        # Generated site; not committed
```

The root project targets Erlang for filesystem-based generation. The separate `widgets/` project targets JavaScript, keeping browser-only dependencies away from the static builder.

## Build pipeline

`npm run build` performs four explicit steps:

1. Gleam discovers routes and collection entries, parses Markdown with Mörk, applies the shared layout, generates discovery files, and copies static assets.
2. The image script converts supported raster files beneath `assets/static/images/` to maximum-width 1000px quality-68 WebP output and derives favicon PNGs from one SVG master.
3. Lustre's development tools bundle the isolated build-receipt widget into `dist/assets/build_receipt.js`.
4. Tailwind scans the source and writes one minified stylesheet.

The final `dist/` directory can be served by any static host.

## Routes and frontmatter

A route's location determines its URL. For example, `routes/studio/index.md` becomes `/studio/`. Every page requires:

```yaml
---
title: Studio — Docklands
description: A useful description for search and social metadata.
---
```

Add `noindex: true` to omit a route or collection entry from the sitemap and emit a robots `noindex` directive.

## Collections

`src/collections.gleam` defines every collection's source directory, route, listing placeholder, item label, and indexing policy. Docklands includes two examples: Guides for documentation and Notes for shorter architectural essays.

Every collection entry requires `title`, `description`, and `published` frontmatter. `featured_image` is optional; when it is present, `featured_alt` is required. Entries are sorted newest-first. A standalone `{{ featured-image }}` placeholder places available artwork, while the collection index uses its configured list placeholder.

Set a collection's `indexable` field to `False` to exclude its index and all entries from search indexing and the sitemap.

## Reusable components

Explicit placeholders are replaced with HTML returned by functions in `src/components.gleam` before Markdown is parsed. This keeps repeated markup in one place without introducing a general template language or constructing every page through an HTML DSL.

## The Lustre island

Only the homepage loads the widget bundle. Lustre mounts on `#build-widget` and owns that one element; navigation, prose, collection pages, and the rest of the document remain static HTML.

## Images and favicons

Drop raster source images into `assets/static/images/`. The build recursively writes optimized WebP versions into `dist/assets/images/`, preserving subdirectories.

The custom site icon lives at `assets/static/favicon.svg`. The build derives a 32px PNG and 180px Apple touch icon from it. Removing the custom file activates `assets/default/favicon.svg` as a neutral fallback.

## Metadata and discovery

The shared layout emits titles, descriptions, canonical URLs, Open Graph fields, X card fields, and icon links. Collection entries use their featured artwork for social previews; ordinary routes use `assets/static/og.png`.

Each build also creates `sitemap.xml`, `robots.txt`, and a non-indexed `404.html`.

## Deploy to Vercel

Import the GitHub repository into Vercel with the root directory left as `./` and the Framework Preset set to **Other**. The checked-in `vercel.json` pins the Gleam compiler, runs the generator on Gleam's JavaScript target, and tells Vercel to publish only `dist/`. No environment variables are required.

Vercel rebuilds and deploys the site whenever the production branch changes. Preview deployments use the same configuration.

## Main dependencies

- [Gleam](https://gleam.run/) — generation and widget language
- [Mörk](https://mork.hexdocs.pm/) — Markdown parsing
- [Simplifile](https://simplifile.hexdocs.pm/) — filesystem operations
- [Tailwind CSS](https://tailwindcss.com/) — static styling
- [Lustre](https://lustre.hexdocs.pm/) — isolated interactive islands
- [esbuild](https://esbuild.github.io/) — JavaScript bundling for the Vercel build\n- [Sharp](https://sharp.pixelplumbing.com/) — build-time image processing

## Deliberate non-goals

Docklands currently has no client-side navigation, site-wide state, site-wide hydration, plugin system, CMS, installable PWA, or service worker. Those should appear only when a real website requirement makes them useful.
