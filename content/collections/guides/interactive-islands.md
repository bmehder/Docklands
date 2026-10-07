---
title: Add an interactive island
description: Use plain JavaScript first, or mount a focused Lustre application without hydrating the site.
published: 2026-09-25
tags: Interactivity, Lustre, JavaScript
featured_image: /assets/images/guide-islands.svg
featured_alt: A focused teal interface island within a larger dark grid
---

# Add an interactive island

{{ featured-image }}

Static HTML is the default. Use plain JavaScript for a small enhancement that does not need an application model. For a stateful widget, use whichever focused browser library suits the feature. Docklands demonstrates Lustre because it is the author's preference when explicit Model, Message, update, and view functions are useful; learning Lustre is not a prerequisite for building a Docklands site.

## Give the widget one mount point

Add an element with a unique ID to the relevant Markdown page. The island starts against that selector and owns only that element. The surrounding heading, prose, navigation, and footer remain static. That boundary works equally well for plain JavaScript, Lustre, or another library that can mount into a chosen element.

## Keep browser code separate

The demo's `widgets/` directory is its own Gleam project targeting JavaScript. This keeps Lustre and browser-only dependencies out of the Erlang-targeted static generator. If your island does not use Lustre, its source and build step can be simpler or use the tooling appropriate to that library.

The homepage build-receipt example lives in `widgets/src/build_receipt.gleam`. The root build bundles it as `dist/assets/build_receipt.js`, and only the homepage loads that module.

For a project-neutral comparison of enhancement scripts and stateful islands, see [Choosing an island](https://themarkdownworks.vercel.app/docs/islands/).

## Know when the island is growing too large

An island should have local state, a clear boundary, and a useful static context around it. If several islands need shared state or navigation control, reconsider the page design before turning the entire website into an application.
