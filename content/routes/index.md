---
title: Docklands — Static sites, clearly built
description: A small, content-first static-site starter for Gleam, Markdown, Tailwind CSS, and optional interactive islands.
published: 2026-09-30
---

<section class='hero'>
  <div class='hero-grid' aria-hidden='true'></div>
  <p class='eyebrow'>A static-site starter for Gleam</p>
  <h1>Static sites,<br><em>clearly built.</em></h1>
  <p class='hero-copy'>Write Markdown. Keep the HTML you understand. Share layout code where repetition becomes annoying. Add interactivity only where it earns its place.</p>
  <div class='hero-actions'>
    <a class='primary-button' href='/guides/first-site/'>Read the first guide <span aria-hidden='true'>↗</span></a>
    <a class='text-link' href='https://github.com/bmehder/Docklands'>View source</a>
  </div>
  <div class='harbour-line' aria-hidden='true'><i></i><i></i><i></i><i></i><span></span></div>
</section>

<section class='manifesto'>
  <p class='section-number'>01 / Intent</p>
  <div>
    <h2>A website first.<br>A system second.</h2>
    <p>Docklands is not a framework competing to own your entire frontend. It is a small reference project for building content-led websites with ordinary output and visible decisions.</p>
  </div>
</section>

<div class='principle-grid' id='principles'>
  <article>
    <span>01</span>
    <h3>Content stays readable</h3>
    <p>Pages and collection items live in Markdown, with raw HTML available when a layout needs more control.</p>
  </article>
  <article>
    <span>02</span>
    <h3>Gleam handles repetition</h3>
    <p>Shared layout, navigation, collection rendering, metadata, and build logic remain small, typed functions.</p>
  </article>
  <article>
    <span>03</span>
    <h3>JavaScript has boundaries</h3>
    <p>Most pages need none. Plain JavaScript, Lustre, or another focused library can own one explicit DOM island when state genuinely helps.</p>
  </article>
</div>

<section class='feature-section' id='features'>
  <div class='feature-heading'>
    <p class='section-number'>02 / Features</p>
    <div>
      <h2>The useful parts are already connected.</h2>
      <p>Docklands provides the small amount of structure a content-led site tends to need, while leaving the result as ordinary HTML, CSS, images, and deliberately chosen JavaScript.</p>
    </div>
  </div>

  <div class='feature-grid'>
    <article>
      <span>Content</span>
      <h3>Markdown with an escape hatch</h3>
      <p>Write readable Markdown for most content and drop into raw HTML whenever a page needs a more deliberate layout.</p>
      <a href='/guides/content-model/'>Explore the content model <span aria-hidden='true'>→</span></a>
    </article>
    <article>
      <span>Routes</span>
      <h3>Portable content, clean URLs</h3>
      <p>Real YAML frontmatter gives every document a title, description, and publication date while folders keep routing in the destination.</p>
      <a href='/guides/routes-and-frontmatter/'>Understand routes <span aria-hidden='true'>→</span></a>
    </article>
    <article>
      <span>Collections</span>
      <h3>Repeatable content, typed in Gleam</h3>
        <p>Define collections once, turn Markdown files into typed items, connect related items with tags, and place generated lists with shortcodes.</p>
      <a href='/guides/collections/'>Build a collection <span aria-hidden='true'>→</span></a>
    </article>
    <article>
      <span>Assets</span>
      <h3>Images prepared at build time</h3>
      <p>Static files are copied as-is, raster images become web-friendly WebP files, and favicon variants are generated for you.</p>
      <a href='/guides/assets-and-images/'>Manage images and icons <span aria-hidden='true'>→</span></a>
    </article>
    <article>
      <span>Discovery</span>
      <h3>Metadata without repetition</h3>
      <p>The shared layout produces canonical links, social metadata, a sitemap, robots.txt, and a proper static 404 page.</p>
      <a href='/guides/build-and-publish/'>See what gets built <span aria-hidden='true'>→</span></a>
    </article>
    <article>
      <span>Interactivity</span>
      <h3>JavaScript stays optional</h3>
      <p>Use plain JavaScript for small enhancements or a focused library for one explicit island. The demo uses Lustre by preference, not as a site-wide requirement.</p>
      <a href='/guides/interactive-islands/'>Add an island <span aria-hidden='true'>→</span></a>
    </article>
  </div>
</section>

---

<section class='output-section'>
  <p class='section-number'>03 / Output</p>
  <h2>Nothing mysterious reaches production.</h2>
  <div class='output-terminal'>
    <div class='terminal-bar'><span></span><span></span><span></span><small>npm run build</small></div>
    <pre><code><b>01</b> Markdown parsed
<b>02</b> Shared layout applied
<b>03</b> Images optimized
<b>04</b> Lustre island bundled
<b>05</b> HTML, CSS and assets written to dist/

<strong>✓ Build complete</strong></code></pre>
  </div>
</section>

---

<section class='island-intro'>
  <p class='section-number'>04 / One island</p>
  <h2>Interactive where useful.<br>Static everywhere else.</h2>
</section>

<div id='build-widget'>Loading build receipt…</div>
<script type='module' src='/assets/build_receipt.js'></script>

<section class='closing-panel'>
  <p class='eyebrow'>Start with the source</p>
  <h2>Small enough to read in one sitting.</h2>
  <p>Follow the build from Markdown input to static output, then change only what your site actually needs.</p>
  <a class='primary-button light' href='/about/'>How Docklands is organised <span aria-hidden='true'>→</span></a>
</section>
