<p align="center">
  <img src="assets/static/docklands-mark.svg" width="72" height="72" alt="Docklands logo">
</p>

# Docklands

A small, content-first static-site starter built with Gleam, Markdown, Tailwind CSS, and optional Lustre islands.

**Live site:** [docklands-ssg.vercel.app](https://docklands-ssg.vercel.app)

Docklands is a reference project rather than a generalized framework. It demonstrates how to build a complete content-led website while keeping the source and generated output easy to understand.

## Philosophy

- Write pages and items primarily in Markdown.
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

Run the regression tests after changing generation logic, content conventions, or the shared layout:

```sh
npm test
```

Before committing, run the complete check. It verifies formatting, generates and tests the static output, and runs the production build:

```sh
npm run check
```

Open [http://localhost:8000](http://localhost:8000). Python's basic server does not automatically use the custom error page, so preview it directly at `/404.html`.

## Project structure

```text
.
├── assets/
│   ├── css/site.css             # Tailwind source and site styles
│   ├── default/favicon.svg      # Neutral fallback icon
│   └── static/                  # Copied assets and image sources
├── content/                     # Author-written Markdown
│   ├── collections/
│   │   ├── guides/              # Practical documentation items
│   │   └── notes/               # Short architectural notes
│   └── routes/                  # Markdown tree mirrored into dist/
│       ├── index.md
│       ├── 404.md
│       ├── about/index.md
│       ├── guides/index.md
│       └── notes/index.md
├── scripts/
│   ├── check-highlighted-code.mjs # Post-build highlighting regression check
│   ├── highlight-code.mjs         # Build-time Shiki transformation
│   └── optimize-images.mjs        # Raster and favicon processing
├── src/
│   ├── collections.gleam        # Collection definitions and item types
│   ├── content.gleam            # Frontmatter, documents, and shortcodes
│   ├── components.gleam         # Reusable static HTML blocks
│   ├── docklands.gleam          # Top-level build orchestration
│   ├── generator.gleam          # Route, collection, tag, and discovery output
│   └── site.gleam               # Shared document layout and navigation
├── test/
│   └── docklands_test.gleam   # Generated-output regression tests
├── widgets/
│   ├── build_receipt_entry.mjs  # Vercel widget-bundle entry point
│   └── src/build_receipt.gleam  # Isolated Lustre build-receipt island
├── vercel.json                  # Vercel build and output settings
└── dist/                        # Generated site; not committed
```

For ordinary website work, think of the directories in two groups:

- **Website authoring:** `content/`, `assets/`, and—when interactivity is useful—`widgets/`.
- **Website generation:** `src/`, `scripts/`, and `test/`.

The remaining root files configure Gleam, npm, Git, and Vercel. The root project targets Erlang for filesystem-based generation. The separate `widgets/` project targets JavaScript, keeping browser-only dependencies away from the static builder.

## Build pipeline

`npm run build` performs five explicit steps:

1. Gleam discovers routes and collection items, parses Markdown with Mörk, applies the shared layout, generates tag archives and discovery files, and copies static assets.
2. Shiki replaces labelled Markdown code fences with build-time syntax-highlighted HTML. Unlabelled and unsupported code remains unchanged, and no highlighting JavaScript is sent to the browser.
3. The image script converts supported raster files beneath `assets/static/images/` to maximum-width 1000px quality-68 WebP output and derives favicon PNGs from one SVG master.
4. Lustre's development tools bundle the isolated build-receipt widget into `dist/assets/build_receipt.js`.
5. Tailwind scans the source and writes one minified stylesheet.

The final `dist/` directory can be served by any static host.

## Routes and frontmatter

A route's location determines its URL. For example, `content/routes/studio/index.md` becomes `/studio/`. Every page requires:

```yaml
---
title: Studio — Docklands
description: A useful description for search and social metadata.
---
```

Add `noindex: true` to omit a route or collection item from the sitemap and emit a robots `noindex` directive.

## Collections

`src/collections.gleam` defines every collection's source directory, route, shortcode, item label, and indexing policy. Docklands includes two examples: Guides for documentation and Notes for shorter architectural essays.

Every collection item requires `title`, `description`, and `published` frontmatter. `featured_image` is optional; when it is present, `featured_alt` is required. Items are sorted newest-first. A standalone `{{ featured-image }}` shortcode places available artwork, while the collection index uses its configured shortcode.

Optional `tags` use a comma-separated list such as `tags: Gleam, Markdown, Deployment`. Tags appear on item pages and collection cards, and each one produces a cross-collection archive under `/tags/<tag>/`. The generated `/tags/` index lists the complete vocabulary and the number of matching items, making existing tags easy to discover without a CMS. Docklands deliberately keeps this author-controlled rather than adding a general taxonomy configuration system.

Set a collection's `indexable` field to `False` to exclude its index and all items from search indexing and the sitemap.

## Reusable components

Shortcodes expand to HTML returned by functions in `src/components.gleam` before Markdown is parsed. A shortcode expands only when it appears on a standalone line outside a fenced code block, so inline and code examples remain literal. This keeps repeated markup in one place without introducing a general template language or constructing every page through an HTML DSL.

## The Lustre island

A small site-wide script reveals the back-to-top control only on long pages after the reader scrolls beyond the first viewport; it scrolls smoothly without changing the URL. Only the homepage loads the widget bundle. Lustre mounts on `#build-widget` and owns that one element; navigation, prose, collection pages, and the rest of the document remain static HTML.

## Images and favicons

Drop raster source images into `assets/static/images/`. The build recursively writes optimized WebP versions into `dist/assets/images/`, preserving subdirectories.

The primary Docklands mark lives at `assets/static/docklands-mark.svg` and is shared by the site header, 404 page, and this README. A matching favicon master lives at `assets/static/favicon.svg`; the build derives a 32px PNG and 180px Apple touch icon from it. Removing the custom favicon activates `assets/default/favicon.svg` as a neutral fallback.

## Metadata and discovery

The shared layout emits titles, descriptions, canonical URLs, Open Graph fields, X card fields, and icon links. Collection items with featured artwork use it for social previews; items without artwork and ordinary routes fall back to `assets/static/og.png`.

Each build also creates tag archive pages, `sitemap.xml`, `robots.txt`, and a non-indexed `404.html`.

## Deploy to Vercel

Import the GitHub repository into Vercel with the root directory left as `./` and the Framework Preset set to **Other**. The checked-in `vercel.json` pins the Gleam compiler, runs the generator on Gleam's JavaScript target, and tells Vercel to publish only `dist/`. No environment variables are required.

The normal local build uses Lustre's development tools and therefore requires Erlang. Vercel instead compiles the widget to JavaScript and bundles the small JavaScript entry module with esbuild, avoiding an Erlang installation in the deployment environment.

Vercel rebuilds and deploys the site whenever the production branch changes. Preview deployments use the same configuration.

## Main dependencies

- [Gleam](https://gleam.run/) — generation and widget language
- [Mörk](https://mork.hexdocs.pm/) — Markdown parsing
- [Simplifile](https://simplifile.hexdocs.pm/) — filesystem operations
- [Tailwind CSS](https://tailwindcss.com/) — static styling
- [Lustre](https://lustre.hexdocs.pm/) — isolated interactive islands
- [esbuild](https://esbuild.github.io/) — JavaScript bundling for the Vercel build
- [Sharp](https://sharp.pixelplumbing.com/) — build-time image processing
- [Shiki](https://shiki.style/) — build-time syntax highlighting

## Deliberate non-goals

Docklands currently has no client-side navigation, site-wide state, site-wide hydration, plugin system, CMS, installable PWA, or service worker. Those should appear only when a real website requirement makes them useful.
