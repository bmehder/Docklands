import content.{
  Document, EmptyRequiredField, InvalidPublishedDate, MissingRequiredField,
  RequiredFieldMustBeString,
}
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

pub fn portable_frontmatter_test() {
  let source = read_generated_file("content/routes/portable/index.md")

  let assert Ok(Document(title:, description:, published:, markdown:, ..)) =
    content.parse_document(source)

  assert title == "A portable page"
  assert description
    == "The same document can supply content to three independent projects."
  assert published == "2026-10-06"
  assert string.contains(markdown, "Markdown works. We build around that.")
}

pub fn quoted_and_plain_dates_match_test() {
  let plain =
    "---\ntitle: Page\ndescription: Summary\npublished: 2024-02-29\n---\n"
  let quoted =
    "---\ntitle: \"Page\"\ndescription: \"Summary\"\npublished: \"2024-02-29\"\n---\n"

  let assert Ok(Document(
    title: plain_title,
    description: plain_description,
    published: plain_published,
    ..,
  )) = content.parse_document(plain)
  let assert Ok(Document(
    title: quoted_title,
    description: quoted_description,
    published: quoted_published,
    ..,
  )) = content.parse_document(quoted)

  assert plain_title == quoted_title
  assert plain_description == quoted_description
  assert plain_published == quoted_published
}

pub fn required_frontmatter_validation_test() {
  let missing = "---\ntitle: Page\ndescription: Summary\n---\n"
  let empty =
    "---\ntitle: '   '\ndescription: Summary\npublished: 2026-10-06\n---\n"
  let wrong_type =
    "---\ntitle: true\ndescription: Summary\npublished: 2026-10-06\n---\n"
  let invalid_date =
    "---\ntitle: Page\ndescription: Summary\npublished: 2026-02-29\n---\n"

  let assert Error(MissingRequiredField("published")) =
    content.parse_document(missing)
  let assert Error(EmptyRequiredField("title")) = content.parse_document(empty)
  let assert Error(RequiredFieldMustBeString("title")) =
    content.parse_document(wrong_type)
  let assert Error(InvalidPublishedDate("2026-02-29")) =
    content.parse_document(invalid_date)
}

pub fn generated_site_test() {
  docklands.main()

  let home_page = read_generated_file("dist/index.html")
  let guide_index = read_generated_file("dist/guides/index.html")
  let content_model =
    read_generated_file("dist/guides/content-model/index.html")
  let collections_guide =
    read_generated_file("dist/guides/collections/index.html")
  let collections_tag = read_generated_file("dist/tags/collections/index.html")
  let tag_index = read_generated_file("dist/tags/index.html")
  let not_found_page = read_generated_file("dist/404.html")
  let portable_page = read_generated_file("dist/portable/index.html")
  let sitemap = read_generated_file("dist/sitemap.xml")
  let robots = read_generated_file("dist/robots.txt")
  let copied_logo = read_generated_file("dist/assets/docklands-mark.svg")
  let back_to_top_script = read_generated_file("dist/assets/back-to-top.js")

  assert string.contains(
    home_page,
    "<link rel='canonical' href='https://docklands-ssg.vercel.app/'>",
  )
  assert string.contains(
    home_page,
    "<script type='module' src='/assets/build_receipt.js'></script>",
  )
  assert string.contains(home_page, "id='features'")
  assert string.contains(home_page, "href='/guides/collections/'")
  assert string.contains(home_page, "Metadata without repetition")
  assert string.contains(home_page, "Portable content, clean URLs")

  assert string.contains(portable_page, "<title>A portable page</title>")
  assert string.contains(portable_page, "Markdown works. We build around that.")
  assert !string.contains(
    portable_page,
    "This nested title is additional metadata",
  )

  assert !string.contains(guide_index, "{{ guide-list }}")
  assert !string.contains(guide_index, "<!-- No featured image -->")
  assert string.contains(guide_index, "href='/guides/content-model/'")

  assert string.contains(
    content_model,
    "<img src='/assets/images/guide-content.svg'",
  )
  assert string.contains(content_model, "<code>{{ featured-image }}</code>")
  assert string.contains(collections_guide, "href='/tags/collections/'")
  assert string.contains(collections_tag, "Everything published with this tag")
  assert string.contains(collections_tag, "href='/guides/collections/'")
  assert string.contains(tag_index, "<h1>Tag index</h1>")
  assert string.contains(tag_index, "href='/tags/static-sites/'")
  assert string.contains(tag_index, "2 items")

  assert string.contains(
    not_found_page,
    "<meta name='robots' content='noindex'>",
  )

  assert string.contains(
    sitemap,
    "<loc>https://docklands-ssg.vercel.app/guides/content-model/</loc>",
  )
  assert string.contains(sitemap, "<lastmod>2026-09-27</lastmod>")
  assert string.contains(
    sitemap,
    "<loc>https://docklands-ssg.vercel.app/portable/</loc>\n    <lastmod>2026-10-06</lastmod>",
  )
  assert string.contains(
    sitemap,
    "<loc>https://docklands-ssg.vercel.app/tags/collections/</loc>",
  )
  assert string.contains(
    sitemap,
    "<loc>https://docklands-ssg.vercel.app/tags/</loc>",
  )
  assert !string.contains(sitemap, "/404.html")

  assert string.contains(
    robots,
    "Sitemap: https://docklands-ssg.vercel.app/sitemap.xml",
  )
  assert string.contains(copied_logo, "<svg")
  assert string.contains(home_page, "data-back-to-top")
  assert string.contains(home_page, "/assets/back-to-top.js")
  assert string.contains(back_to_top_script, "window.scrollTo")
}

fn read_generated_file(path: String) -> String {
  let assert Ok(contents) = simplifile.read(from: path)
  contents
}
