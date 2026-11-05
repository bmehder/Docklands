---
title: Find your way around the project
description: Learn which Docklands directory owns content, generation, assets, widgets, and generated output.
published: 2026-09-29
tags: Getting started, Project structure
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
- `widgets/` contains optional browser-side islands. The included demo is a separate Gleam project using Lustre, but a site may use plain JavaScript or another focused library instead.

## Website generation

The remaining working directories explain how Docklands turns those inputs into a website:

- `src/` contains the small Gleam build pipeline. `config.gleam` is the central place for site identity, navigation, enabled site-wide features, and collection configuration. `docklands.gleam` orchestrates the build, `content.gleam` parses frontmatter, `shortcodes.gleam` expands explicit Markdown markers, and `generator.gleam` writes routes, collection items, tags, the sitemap, and robots file. `collections.gleam` owns collection item types and rendering, `layout.gleam` owns the shared page structure, and `output.gleam` contains the small URL and escaping helpers used while generating files.
- `scripts/` contains supporting build steps that do not belong in the generator, including publishing and checking the generated Gleam reference.
- `test/` verifies the generated output and important URL behaviour.

The generated `dist/` directory is output, not source. Delete it, rebuild it, or deploy it, but do not edit it by hand—the next build replaces it.

The modules, types, and functions that form the supported SSG surface use Gleam documentation comments. Each complete build publishes their generated, searchable reference beneath `dist/reference/`; site-specific implementation modules are marked internal in `gleam.toml` and stay out of that reference.

## Follow ownership, not file extensions

Markdown owns page content. Gleam owns repeated structure and generation. CSS owns presentation. A widget owns only its named DOM island. Keeping those boundaries visible is more important than making every file look uniform.

## Start with the smallest relevant file

For a copy change, begin in `content/routes/` or `content/collections/`. For the site name, base URL, GitHub link, navigation, back-to-top setting, or collection definitions, begin in `src/config.gleam`. Shared page markup belongs in `src/layout.gleam`; collection and item rendering belongs in `src/collections.gleam`; shortcode matching belongs in `src/shortcodes.gleam`; shared output formatting belongs in `src/output.gleam`. Parsing conventions belong in `src/content.gleam`, while generated page behaviour belongs in `src/generator.gleam`. Move into build code only when the behaviour truly applies across the site.

Set `github_url` to `None` when the header should not show a GitHub link. Use `Some("https://github.com/example/project")` to enable it.
