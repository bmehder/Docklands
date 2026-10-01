import gleam/option.{type Option}

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
    featured_image: Option(FeaturedImage),
    indexable: Bool,
    markdown: String,
  )
}

pub fn all() -> List(Collection) {
  [
    Collection(
      source_directory: "collections/guides",
      route: "guides",
      shortcode: "{{ guide-list }}",
      item_label: "guide",
      indexable: True,
    ),
    Collection(
      source_directory: "collections/notes",
      route: "notes",
      shortcode: "{{ note-list }}",
      item_label: "note",
      indexable: True,
    ),
  ]
}
