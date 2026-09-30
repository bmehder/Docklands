---
title: Create and change collections
description: Add repeatable content types, configure their listings, and understand required and optional entry fields.
published: 2026-09-27
---

# Create and change collections

Collections are for content that repeats with a shared shape and presentation. Guides and Notes demonstrate two collections without turning Docklands into a general-purpose CMS.

## Define the collection once

Add a `Collection` value in `src/collections.gleam`. It specifies the source directory, public route, listing placeholder, singular item label, and whether the collection is indexable.

Then add an index route such as `routes/notes/index.md`. Put its configured list placeholder on a line by itself where the cards should appear.

## Write entries

Each Markdown file in the collection directory becomes an entry. These fields are required:

- `title`
- `description`
- `published` in `YYYY-MM-DD` form

Featured artwork is optional. If you add `featured_image`, also add useful `featured_alt` text. Entries without artwork simply render without an image area in both the listing and the article.

## Change the content model deliberately

The `Entry` type in `src/collections.gleam` is the schema. Add a field there only when the collection rendering or metadata needs it. Parse it in `load_entry`, then use it in a component or page builder. This small amount of explicit wiring makes missing assumptions visible at build time.

## Rename a collection

Rename its content directory and index route, then update the matching `Collection` configuration and navigation links. Because URLs change, a mature public site should also add redirects at its hosting layer.
