---
title: Find your way around the project
description: Learn which Docklands directory owns content, generation, assets, widgets, and generated output.
published: 2026-09-29
---

# Find your way around the project

Docklands keeps each kind of work in an obvious place. You should rarely need to hunt through the project to answer “where does this belong?”

## The five working areas

- `routes/` contains standalone pages and collection index pages.
- `collections/` contains repeatable entries such as guides and notes.
- `src/` contains the Gleam generator, shared layout, configuration, and reusable HTML components.
- `assets/` contains stylesheet source, files copied as-is, and raster images optimized during the build.
- `widgets/` is a separate Gleam project for optional browser-side Lustre islands.

The generated `dist/` directory is output, not source. Delete it, rebuild it, or deploy it, but do not edit it by hand—the next build replaces it.

## Follow ownership, not file extensions

Markdown owns page content. Gleam owns repeated structure and generation. CSS owns presentation. A widget owns only its named DOM island. Keeping those boundaries visible is more important than making every file look uniform.

## Start with the smallest relevant file

For a copy change, begin in `routes/` or `collections/`. For shared navigation or metadata, begin in `src/site.gleam`. For a repeated content block, look in `src/components.gleam`. Move into build code only when the behaviour truly applies across the site.
