import gleam/option.{type Option}
import gleam/string
import gleam/uri

pub type Collection {
  Collection(
    source_directory: String,
    route: String,
    shortcode: String,
    item_label: String,
    indexable: Bool,
  )
}

pub type FeaturedImage {
  FeaturedImage(src: String, alt: String)
}

pub type Item {
  Item(
    slug: String,
    title: String,
    description: String,
    published: String,
    tags: List(String),
    featured_image: Option(FeaturedImage),
    indexable: Bool,
    markdown: String,
  )
}

pub fn tag_slug(tag: String) -> String {
  tag
  |> string.trim
  |> string.lowercase
  |> string.replace(" ", "-")
  |> uri.percent_encode
}

pub fn all() -> List(Collection) {
  [
    Collection(
      source_directory: "content/collections/guides",
      route: "guides",
      shortcode: "{{ guide-list }}",
      item_label: "guide",
      indexable: True,
    ),
    Collection(
      source_directory: "content/collections/notes",
      route: "notes",
      shortcode: "{{ note-list }}",
      item_label: "note",
      indexable: True,
    ),
  ]
}
