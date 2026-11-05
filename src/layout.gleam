import config
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import output

pub type Metadata {
  Metadata(
    title: String,
    description: String,
    path: String,
    image: String,
    page_type: String,
    indexable: Bool,
  )
}

pub fn page(metadata: Metadata, content: String) -> String {
  "<!doctype html>
<html lang='en'>
  " <> document_head(metadata) <> "
  <body class='min-h-screen bg-[#071014] font-sans text-slate-100 antialiased'>
    " <> header() <> "
    <main class='page-content'>
      <div>
      " <> content <> "
      </div>
    </main>
    " <> footer() <> back_to_top() <> "
  </body>
</html>
"
}

fn document_head(metadata: Metadata) -> String {
  let Metadata(title:, description:, path:, image:, page_type:, indexable:) =
    metadata
  let title = output.escape_html(title)
  let description = output.escape_html(description)
  let canonical_url = path |> output.absolute_url |> output.escape_html
  let image_url = image |> output.absolute_url |> output.escape_html
  let robots = case indexable {
    True -> ""
    False -> "\n    <meta name='robots' content='noindex'>"
  }

  "<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <meta name='theme-color' content='#071014'>
    <title>" <> title <> "</title>
    <meta name='description' content='" <> description <> "'>
    <link rel='canonical' href='" <> canonical_url <> "'>" <> robots <> "
    <meta property='og:title' content='" <> title <> "'>
    <meta property='og:description' content='" <> description <> "'>
    <meta property='og:type' content='" <> page_type <> "'>
    <meta property='og:url' content='" <> canonical_url <> "'>
    <meta property='og:image' content='" <> image_url <> "'>
    <meta name='twitter:card' content='summary_large_image'>
    <meta name='twitter:title' content='" <> title <> "'>
    <meta name='twitter:description' content='" <> description <> "'>
    <meta name='twitter:image' content='" <> image_url <> "'>
    <link rel='icon' href='/favicon.svg' type='image/svg+xml'>
    <link rel='icon' href='/favicon-32.png' type='image/png' sizes='32x32'>
    <link rel='apple-touch-icon' href='/apple-touch-icon.png' sizes='180x180'>
    <link rel='stylesheet' href='/assets/site.css'>
  </head>"
}

fn header() -> String {
  let navigation_links = navigation_links()

  "<header class='site-header'>
    <div class='header-inner'>
      <a class='brand' href='/'>
        <img src='/assets/docklands-mark.svg' alt='' width='38' height='38'>
        <span>" <> output.escape_html(config.name) <> "</span>
      </a>
      <nav class='desktop-nav' aria-label='Main navigation'>
        " <> navigation_links <> "
        " <> github_link() <> "
      </nav>
      <div class='header-meta'>
        <span class='build-pill'>Gleam → static HTML</span>
        <details class='mobile-menu'>
          <summary aria-label='Open navigation'>Menu</summary>
          <nav aria-label='Mobile navigation'>
            " <> navigation_links <> "
            " <> github_link() <> "
          </nav>
        </details>
      </div>
    </div>
  </header>"
}

fn navigation_links() -> String {
  config.navigation()
  |> list.map(fn(link) {
    let #(label, path) = link

    "<a href='"
    <> output.escape_html(path)
    <> "'>"
    <> output.escape_html(label)
    <> "</a>"
  })
  |> string.join("\n")
}

fn github_link() -> String {
  case config.github_url {
    None -> ""
    Some(github_url) ->
      "<a class='github-link' href='"
      <> output.escape_html(github_url)
      <> "' target='_blank' rel='noreferrer' aria-label='"
      <> output.escape_html(config.name)
      <> " on GitHub'>
    <svg viewBox='0 0 24 24' aria-hidden='true'><path fill='currentColor' d='M12 .7a11.5 11.5 0 0 0-3.64 22.41c.58.11.79-.25.79-.56v-2.23c-3.23.7-3.91-1.37-3.91-1.37-.53-1.34-1.29-1.7-1.29-1.7-1.05-.72.08-.71.08-.71 1.17.08 1.78 1.2 1.78 1.2 1.04 1.77 2.72 1.26 3.38.96.1-.75.4-1.26.74-1.55-2.58-.29-5.29-1.29-5.29-5.69 0-1.26.45-2.29 1.19-3.1-.12-.29-.52-1.47.11-3.06 0 0 .97-.31 3.16 1.18a10.9 10.9 0 0 1 5.76 0c2.19-1.49 3.16-1.18 3.16-1.18.63 1.59.23 2.77.11 3.06.74.81 1.19 1.84 1.19 3.1 0 4.42-2.72 5.39-5.31 5.68.42.36.79 1.07.79 2.16v3.21c0 .31.21.68.8.56A11.5 11.5 0 0 0 12 .7Z'/></svg>
  </a>"
  }
}

fn back_to_top() -> String {
  case config.back_to_top {
    False -> ""
    True ->
      "<button class='back-to-top' type='button' data-back-to-top aria-label='Back to top' title='Back to top' hidden>
    <svg viewBox='0 0 24 24' aria-hidden='true'>
      <path d='m6 10 6-6 6 6M12 4v16' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'/>
    </svg>
  </button>
  <script src='/assets/back-to-top.js' defer></script>"
  }
}

fn footer() -> String {
  "<footer class='site-footer'>
    <div class='footer-inner'>
      <p>" <> output.escape_html(config.name) <> "</p>
      <p>Content in. Static files out.</p>
      <p>Built carefully with Gleam.</p>
    </div>
  </footer>"
}
