import gleam/option.{type Option}

pub type Collection {
  Collection(
    source_directory: String,
    route: String,
    placeholder: String,
    item_label: String,
    indexable: Bool,
  )
}

pub type FeaturedImage {
  FeaturedImage(src: String, alt: String)
}

pub type Entry {
  Entry(
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
      placeholder: "{{ guide-list }}",
      item_label: "guide",
      indexable: True,
    ),
    Collection(
      source_directory: "collections/notes",
      route: "notes",
      placeholder: "{{ note-list }}",
      item_label: "note",
      indexable: True,
    ),
  ]
}
