---
title: Build your first Docklands site
description: Follow one page from Markdown source to complete static HTML output.
published: 2026-09-30
tags: Getting started, Markdown, Build
featured_image: /assets/images/guide-foundations.svg
featured_alt: An abstract structural grid with four illuminated vertical supports
---

# Build your first Docklands site

{{ featured-image }}

The shortest way to understand Docklands is to follow one page through the build. There is no hidden runtime and no application shell waiting in the browser.

## Begin with a route

Create an `index.md` file beneath `content/routes/`. Its directory becomes the public URL, while its title and description become document metadata.

```text
content/routes/
└── studio/
    └── index.md
```

The Markdown body can contain ordinary prose, lists, links, and raw HTML whenever a section needs deliberate structure.

## Run the complete build

The root build command performs the whole journey in two phases:

1. `build:pages` runs Gleam. It discovers routes and collection items, uses Mörk to convert Markdown, applies the shared layout, writes tag pages, sitemap, and robots file, and copies passthrough assets.
2. `build:postprocess` highlights code, writes optimized WebP and favicon files, bundles the isolated widget, and compiles the Tailwind stylesheet.

Everything deployable lands in `dist/`. Raster source images do not: Sharp is the only step that writes raster files beneath `dist/assets/images/`.

## Read the output

Open the generated HTML. It is the best documentation for what the browser receives: complete markup, one stylesheet, static assets, and JavaScript only on the page that mounts the Lustre island.
