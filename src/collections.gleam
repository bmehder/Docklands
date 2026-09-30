pub type Collection {
  Collection(
    source_directory: String,
    route: String,
    placeholder: String,
    item_label: String,
    indexable: Bool,
  )
}

pub type Entry {
  Entry(
    slug: String,
    title: String,
    description: String,
    published: String,
    featured_image: String,
    featured_alt: String,
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
      source_directory: "collections/dispatches",
      route: "dispatches",
      placeholder: "{{ dispatch-list }}",
      item_label: "dispatch",
      indexable: True,
    ),
  ]
}
