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

Static HTML is the default. Use plain JavaScript for a small enhancement that does not need an application model. Reach for Lustre when a particular feature benefits from explicit Model, Message, update, and view functions.

## Give the widget one mount point

Add an element with a unique ID to the relevant Markdown page. The Lustre application starts against that selector and owns only that element. The surrounding heading, prose, navigation, and footer remain static.

## Keep browser code separate

The `widgets/` directory is its own Gleam project targeting JavaScript. This keeps Lustre and browser-only dependencies out of the Erlang-targeted static generator.

The homepage build-receipt example lives in `widgets/src/build_receipt.gleam`. The root build bundles it as `dist/assets/build_receipt.js`, and only the homepage loads that module.

## Know when the island is growing too large

An island should have local state, a clear boundary, and a useful static context around it. If several islands need shared state or navigation control, reconsider the page design before turning the entire website into an application.
