//// Defines the collection model exposed by the static-site generator.
////
//// This website's identity, navigation, and enabled collections are kept in
//// the same file for convenience, but are internal rather than public API.

/// Describes a directory of Markdown items and the pages generated from it.
pub type Collection {
  Collection(
    source_directory: String,
    route: String,
    shortcode: String,
    item_label: String,
    indexable: Bool,
  )
}

@internal
pub const name = "Docklands"

@internal
pub const base_url = "https://docklands-ssg.vercel.app"

@internal
pub const github_url: Option(String) = Some(
  "https://github.com/bmehder/Docklands",
)

@internal
pub const back_to_top = True

@internal
pub fn navigation() -> List(#(String, String)) {
  [
    #("Home", "/"),
    #("About", "/about/"),
    #("Guides", "/guides/"),
    #("Notes", "/notes/"),
    #("Tags", "/tags/"),
    #("Reference", "/reference/"),
  ]
}

@internal
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
