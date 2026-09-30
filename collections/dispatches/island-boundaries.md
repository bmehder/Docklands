---
title: Give every interactive island a shoreline
description: A small DOM boundary keeps interactive state from becoming site architecture.
published: 2026-09-25
featured_image: /assets/images/dispatch-boundaries.svg
featured_alt: Two abstract panels connected across a clear boundary
---

# Give every interactive island a shoreline

{{ featured-image }}

An island is useful because it has an edge. Outside that edge, the document remains ordinary server-rendered HTML. Inside it, a focused application can use Model, Msg, update, and view.

## Ownership should be visible

Docklands mounts a Lustre application on one element by ID. Lustre replaces and manages that element, but it does not hydrate the header, footer, prose, or navigation.

A good island has:

1. A clear mount point
2. State that belongs only to that feature
3. A page-specific script
4. Useful static context around it

## Resist the expanding coastline

When two interactive regions need shared state, it may be time to reconsider the boundary. It is not automatically time to make the entire website an application.
