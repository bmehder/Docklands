---
title: Create and change collections
description: Add repeatable content types, configure their listings, and understand required and optional item fields.
published: 2026-09-27
tags: Collections, Content model, Frontmatter
featured_image: /assets/images/guide-collections.svg
featured_alt: Four coordinated content cards arranged in a dark grid
---

# Create and change collections

{{ featured-image }}

Collections are for content that repeats with a shared shape and presentation. Guides and Notes demonstrate two collections without turning Docklands into a general-purpose CMS.

## Define the collection once

Add a `Collection` value to the `collections` function in `src/config.gleam`. It specifies the source directory, public route, shortcode, singular item label, and whether the collection is indexable.

Then add an index route such as `content/routes/notes/index.md`. Put its configured shortcode on a line by itself where the cards should appear.

## Write items

Each Markdown file in the collection directory becomes an item. These fields are required:

- `title`
- `description`
- `published` in `YYYY-MM-DD` form

Featured artwork is optional. If you add `featured_image`, also add useful `featured_alt` text. Items without artwork simply render without an image area in both the listing and the article.

Use `series_label` when an item belongs to a named sequence. Use `publication_order` only when several items share a publication date and need an explicit tie-break order:

```yaml
publication_order: 2
series_label: Programming with Values · Part 2 of 3
```

Tags are optional too. Supply a comma-separated list when an item belongs to one or more topics:

```yaml
tags: Gleam, Markdown, Deployment
```

Docklands displays those tags on the item and its collection card. Each tag links to an automatically generated archive such as `/tags/gleam/`, which can include matching items from any collection. The `/tags/` index lists every existing tag with its item count, so authors can check the vocabulary before adding another. Keep tag spelling and capitalisation consistent: tags are intentionally a small, author-controlled vocabulary rather than a CMS subsystem. Omitting `tags` produces an empty list; no `Option` wrapper is needed for a zero-or-more value.

## Change the content model deliberately

The `Item` type in `src/collections.gleam` is the schema. Add a field there only when collection rendering or metadata needs it. Parse it in `load_item`, then use it in the relevant rendering section or page builder. This small amount of explicit wiring makes missing assumptions visible at build time.

## Rename a collection

Rename its content directory and index route, then update the matching `Collection` configuration and navigation links. Because URLs change, a mature public site should also add redirects at its hosting layer.
