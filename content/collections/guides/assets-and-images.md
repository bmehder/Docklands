---
title: Work with assets, images, and icons
description: Copy static files, optimize raster images during builds, and customize Docklands favicons.
published: 2026-09-26
tags: Assets, Images, Build
featured_image: /assets/images/guide-assets.svg
featured_alt: An abstract framed image with teal landscape lines and an amber sun
---

# Work with assets, images, and icons

{{ featured-image }}

Web-ready files beneath `assets/static/` are copied into `dist/assets/`. Raster sources beneath `assets/static/images/` are the exception: Gleam leaves them out of the passthrough copy, and Sharp writes only their optimized WebP output. That keeps source paths predictable while keeping generated output disposable and small.

## Add an ordinary asset

Place SVGs, downloadable files, or other already web-ready assets beneath `assets/static/`. Preserve useful subdirectories, then reference the public path beginning with `/assets/`.

## Add a raster image

Drop JPEG, PNG, WebP, AVIF, or TIFF source files beneath `assets/static/images/`. During `npm run build`, the image step creates WebP output up to 1000 pixels wide at the configured quality and preserves nested folders.

The source file stays untouched but is not copied into `dist/`. Inspect the matching WebP file in `dist/assets/images/` to see the deployable result. Sharp is the only build step that writes raster images to that directory, so an original PNG or JPEG is not deployed beside its optimized version. This optimisation occurs on every complete build, not while the local server is merely serving an existing `dist/` directory.

## Use optional featured artwork

A collection item may omit image metadata entirely. To add artwork, supply both fields:

```yaml
featured_image: /assets/images/harbour-map.webp
featured_alt: A simplified map of the harbour and its surrounding streets
```

Place the `{{ featured-image }}` shortcode on its own line in the item body when you want the artwork inside the article.

## Customize the favicon

`assets/static/favicon.svg` is the site-specific master. The build derives a 32-pixel PNG and an Apple touch icon from it. If that file is absent, the neutral icon in `assets/default/favicon.svg` is used instead.
