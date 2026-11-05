pub type Collection {
  Collection(
    source_directory: String,
    route: String,
    shortcode: String,
    item_label: String,
    indexable: Bool,
  )
}

pub const name = "Docklands"

pub const base_url = "https://docklands-ssg.vercel.app"

pub const github_url: Option(String) = Some(
  "https://github.com/bmehder/Docklands",
)

pub const back_to_top = True

pub fn navigation() -> List(#(String, String)) {
  [
    #("Home", "/"),
    #("About", "/about/"),
    #("Guides", "/guides/"),
    #("Notes", "/notes/"),
    #("Tags", "/tags/"),
  ]
}

pub fn collections() -> List(Collection) {
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

import gleam/option.{type Option, Some}
