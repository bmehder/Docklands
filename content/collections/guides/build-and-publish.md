---
title: Build, preview, and publish
description: Run the complete Docklands build, serve its static output locally, and deploy it to a static host.
published: 2026-09-24
tags: Build, Deployment, Static sites
featured_image: /assets/images/guide-publish.svg
featured_alt: Three connected build stages ending in an amber deployment node
---

# Build, preview, and publish

{{ featured-image }}

Docklands has one complete build command with two visible phases. Gleam first generates the pages and passthrough assets. The postprocess phase then highlights code, optimizes images, bundles the optional widget, compiles the stylesheet, and generates the Gleam reference documentation.

## Build the site

```sh
npm install
npm run build
```

The resulting `dist/` directory is the whole deployable website. `build:pages` can be run independently while working on generation code, but only the complete `npm run build` command produces the finished site.

The generated SSG reference is available at `/reference/`. It complements the task-oriented guides with searchable documentation derived directly from the public Gleam modules, types, functions, and their documentation comments.

## Preview it locally

```sh
npm run serve
```

Open `http://localhost:8000`. The server only reads the current contents of `dist/`, so rebuild after changing Markdown, Gleam, CSS, images, or widget code. Stop it with Control-C.

Python's simple server does not apply the custom error document automatically. Open `/404.html` directly when you want to inspect that page.

## Publish ordinary files

Any static host can serve `dist/`. Configure the host's build command as `npm run build` and its output directory as `dist`. Docklands itself does not require a server process, database, client-side router, or framework runtime in production.
