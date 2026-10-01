import docklands
import gleam/string
import gleeunit
import simplifile
import site

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn absolute_url_test() {
  assert site.absolute_url("/guides/content-model/")
    == "https://docklands-ssg.vercel.app/guides/content-model/"
  assert site.absolute_url("https://cdn.example.com/image.webp")
    == "https://cdn.example.com/image.webp"
}

pub fn generated_site_test() {
  docklands.main()

  let home_page = read_generated_file("dist/index.html")
  let guide_index = read_generated_file("dist/guides/index.html")
  let content_model =
    read_generated_file("dist/guides/content-model/index.html")
  let not_found_page = read_generated_file("dist/404.html")
  let sitemap = read_generated_file("dist/sitemap.xml")
  let robots = read_generated_file("dist/robots.txt")
  let copied_logo = read_generated_file("dist/assets/docklands-mark.svg")

  assert string.contains(
    home_page,
    "<link rel='canonical' href='https://docklands-ssg.vercel.app/'>",
  )
  assert string.contains(
    home_page,
    "<script type='module' src='/assets/build_receipt.js'></script>",
  )

  assert !string.contains(guide_index, "{{ guide-list }}")
  assert !string.contains(guide_index, "<!-- No featured image -->")
  assert string.contains(guide_index, "href='/guides/content-model/'")

  assert string.contains(
    content_model,
    "<img src='/assets/images/guide-content.svg'",
  )
  assert string.contains(content_model, "<code>{{ featured-image }}</code>")

  assert string.contains(
    not_found_page,
    "<meta name='robots' content='noindex'>",
  )

  assert string.contains(
    sitemap,
    "<loc>https://docklands-ssg.vercel.app/guides/content-model/</loc>",
  )
  assert string.contains(sitemap, "<lastmod>2026-09-27</lastmod>")
  assert !string.contains(sitemap, "/404.html")

  assert string.contains(
    robots,
    "Sitemap: https://docklands-ssg.vercel.app/sitemap.xml",
  )
  assert string.contains(copied_logo, "<svg")
}

fn read_generated_file(path: String) -> String {
  let assert Ok(contents) = simplifile.read(from: path)
  contents
}
