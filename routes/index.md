---
title: Docklands — Static sites, clearly built
description: A small, content-first static-site starter for Gleam, Markdown, Tailwind CSS, and optional Lustre islands.
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
    <p>Pages and collection entries live in Markdown, with raw HTML available when a layout needs more control.</p>
  </article>
  <article>
    <span>02</span>
    <h3>Gleam handles repetition</h3>
    <p>Shared layout, navigation, collection rendering, metadata, and build logic remain small, typed functions.</p>
  </article>
  <article>
    <span>03</span>
    <h3>JavaScript has boundaries</h3>
    <p>Most pages need none. A Lustre island can own one explicit DOM node when state genuinely helps.</p>
  </article>
</div>

---

<section class='output-section'>
  <p class='section-number'>02 / Output</p>
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
  <p class='section-number'>03 / One island</p>
  <h2>Interactive where useful.<br>Static everywhere else.</h2>
</section>

<div id='build-widget'>Loading build receipt…</div>
<script type='module' src='/assets/dispatch.js'></script>

<section class='closing-panel'>
  <p class='eyebrow'>Start with the source</p>
  <h2>Small enough to read in one sitting.</h2>
  <p>Follow the build from Markdown input to static output, then change only what your site actually needs.</p>
  <a class='primary-button light' href='/about/'>How Docklands is organised <span aria-hidden='true'>→</span></a>
</section>
