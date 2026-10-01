---
title: Build, preview, and publish
description: Run the complete Docklands build, serve its static output locally, and deploy it to a static host.
published: 2026-09-24
---

# Build, preview, and publish

Docklands has one complete build command. It generates pages, optimizes images, bundles the optional widget, and compiles the stylesheet.

## Build the site

```sh
npm install
npm run build
```

The resulting `dist/` directory is the whole deployable website. A successful build reports the number of routes and collection items it generated.

## Preview it locally

```sh
npm run serve
```

Open `http://localhost:8000`. The server only reads the current contents of `dist/`, so rebuild after changing Markdown, Gleam, CSS, images, or widget code. Stop it with Control-C.

Python's simple server does not apply the custom error document automatically. Open `/404.html` directly when you want to inspect that page.

## Publish ordinary files

Any static host can serve `dist/`. Configure the host's build command as `npm run build` and its output directory as `dist`. Docklands itself does not require a server process, database, client-side router, or framework runtime in production.
