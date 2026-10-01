---
title: Find your way around the project
description: Learn which Docklands directory owns content, generation, assets, widgets, and generated output.
published: 2026-09-29
featured_image: /assets/images/guide-structure.svg
featured_alt: A branching project structure connecting one root to three modules
---

# Find your way around the project

{{ featured-image }}

Docklands keeps each kind of work in an obvious place. You should rarely need to hunt through the project to answer “where does this belong?”

## Website authoring

Most website changes begin in one of three places:

- `content/` contains Markdown. Its `routes/` directory holds standalone pages and collection indexes; its `collections/` directory holds repeatable items such as guides and notes.
- `assets/` contains stylesheet source, files copied as-is, and raster images optimized during the build.
- `widgets/` is a separate Gleam project for optional browser-side Lustre islands.

## Website generation

The remaining working directories explain how Docklands turns those inputs into a website:

- `src/` contains the Gleam generator, shared layout, collection configuration, and reusable HTML components.
- `scripts/` contains supporting build steps that do not belong in the generator.
- `test/` verifies the generated output and important URL behaviour.

The generated `dist/` directory is output, not source. Delete it, rebuild it, or deploy it, but do not edit it by hand—the next build replaces it.

## Follow ownership, not file extensions

Markdown owns page content. Gleam owns repeated structure and generation. CSS owns presentation. A widget owns only its named DOM island. Keeping those boundaries visible is more important than making every file look uniform.

## Start with the smallest relevant file

For a copy change, begin in `content/routes/` or `content/collections/`. For shared navigation or metadata, begin in `src/site.gleam`. For a repeated content block, look in `src/components.gleam`. Move into build code only when the behaviour truly applies across the site.
