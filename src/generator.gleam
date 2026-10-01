import collections.{type Collection, type Item, Collection, FeaturedImage, Item}
import components
import content.{type Shortcode, Document, Shortcode}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import mork
import simplifile
import site

const routes_directory = "content/routes"

pub type LoadedCollection {
  LoadedCollection(collection: Collection, items: List(Item))
}

type TaggedItem {
  TaggedItem(route: String, item_label: String, item: Item)
}

// Counts used by the build summary

pub fn item_count(loaded_collections: List(LoadedCollection)) -> Int {
  loaded_collections
  |> list.fold(0, fn(total, loaded_collection) {
    let LoadedCollection(items:, ..) = loaded_collection
    total + list.length(items)
  })
}

pub fn tag_count(loaded_collections: List(LoadedCollection)) -> Int {
  loaded_collections
  |> indexable_tagged_items
  |> tag_names
  |> list.length
}

// Routes

pub fn load_routes() -> List(String) {
  let assert Ok(files) = simplifile.get_files(in: routes_directory)

  files
  |> list.filter(string.ends_with(_, ".md"))
  |> list.sort(string.compare)
}

pub fn build_routes(
  route_sources: List(String),
  shortcodes: List(Shortcode),
  loaded_collections: List(LoadedCollection),
) -> Nil {
  list.each(route_sources, build_route(_, shortcodes, loaded_collections))
}

fn build_route(
  source_path: String,
  shortcodes: List(Shortcode),
  loaded_collections: List(LoadedCollection),
) -> Nil {
  let assert Ok(source_markdown) = simplifile.read(from: source_path)

  let Document(title:, description:, indexable:, markdown:) =
    content.parse_document(source_markdown)

  let relative_path = route_relative_path(source_path)
  let output_path = "dist/" <> string.drop_end(relative_path, 3) <> ".html"
  let output_directory = output_directory(output_path)

  let rendered_content =
    markdown
    |> content.expand_shortcodes(shortcodes)
    |> mork.parse
    |> mork.to_html

  let path = route_path(relative_path)
  let html =
    site.page(
      site.Metadata(
        title:,
        description:,
        path:,
        image: "/assets/og.png",
        page_type: "website",
        indexable: indexable && route_is_indexable(path, loaded_collections),
      ),
      rendered_content,
    )

  let assert Ok(Nil) = simplifile.create_directory_all(output_directory)
  let assert Ok(Nil) = simplifile.write(to: output_path, contents: html)
  Nil
}

fn route_relative_path(source_path: String) -> String {
  string.drop_start(source_path, string.length(routes_directory) + 1)
}

fn route_path(relative_path: String) -> String {
  case relative_path {
    "index.md" -> "/"
    "404.md" -> "/404.html"
    path -> "/" <> string.drop_end(path, 8)
  }
}

fn route_is_indexable(
  path: String,
  loaded_collections: List(LoadedCollection),
) -> Bool {
  case path {
    "/404.html" -> False
    _ ->
      loaded_collections
      |> list.all(fn(loaded_collection) {
        let LoadedCollection(
          collection: Collection(route:, indexable: collection_is_indexable, ..),
          ..,
        ) = loaded_collection

        let is_collection_index = path == "/" <> route <> "/"

        case is_collection_index {
          True -> collection_is_indexable
          False -> True
        }
      })
  }
}

fn output_directory(output_path: String) -> String {
  let parts = string.split(output_path, on: "/")

  parts
  |> list.take(list.length(parts) - 1)
  |> string.join("/")
}

// Collections

pub fn load_collections(
  configured_collections: List(Collection),
) -> List(LoadedCollection) {
  list.map(configured_collections, load_collection)
}

fn load_collection(collection: Collection) -> LoadedCollection {
  let Collection(source_directory:, ..) = collection
  let assert Ok(filenames) = simplifile.read_directory(at: source_directory)

  let items =
    filenames
    |> list.filter(string.ends_with(_, ".md"))
    |> list.sort(string.compare)
    |> list.map(load_item(collection, _))
    |> list.sort(by: newest_first)

  LoadedCollection(collection:, items:)
}

fn load_item(collection: Collection, source_filename: String) -> Item {
  let Collection(source_directory:, indexable: collection_is_indexable, ..) =
    collection

  let assert Ok(source_markdown) =
    simplifile.read(from: source_directory <> "/" <> source_filename)

  let slug = string.drop_end(source_filename, 3)

  let Document(title:, description:, indexable:, markdown:) =
    content.parse_document(source_markdown)

  let #(frontmatter, _) = mork.split_frontmatter_from_input(source_markdown)

  let assert Ok(published) = content.frontmatter_value(frontmatter, "published")
  let tags = content.frontmatter_list(frontmatter, "tags")
  let featured_image = content.parse_featured_image(frontmatter)

  Item(
    slug:,
    title:,
    description:,
    published:,
    tags:,
    featured_image:,
    indexable: collection_is_indexable && indexable,
    markdown:,
  )
}

fn newest_first(first_item: Item, second_item: Item) {
  let Item(published: first_date, ..) = first_item
  let Item(published: second_date, ..) = second_item

  string.compare(second_date, first_date)
}

pub fn collection_shortcodes(
  loaded_collections: List(LoadedCollection),
) -> List(Shortcode) {
  list.map(loaded_collections, collection_shortcode)
}

fn collection_shortcode(loaded_collection: LoadedCollection) -> Shortcode {
  let LoadedCollection(
    collection: Collection(route:, shortcode:, item_label:, ..),
    items:,
  ) = loaded_collection

  Shortcode(
    marker: shortcode,
    html: components.collection_list(route, item_label, items),
  )
}

pub fn build_collections(
  loaded_collections: List(LoadedCollection),
  shortcodes: List(Shortcode),
) -> Nil {
  list.each(loaded_collections, build_collection(_, shortcodes))
}

fn build_collection(
  loaded_collection: LoadedCollection,
  shortcodes: List(Shortcode),
) -> Nil {
  let LoadedCollection(collection:, items:) = loaded_collection

  list.each(items, build_item(collection, _, shortcodes))
}

fn build_item(
  collection: Collection,
  item: Item,
  shortcodes: List(Shortcode),
) -> Nil {
  let Collection(route:, item_label:, ..) = collection

  let Item(slug:, title:, description:, published:, tags:, markdown:, ..) = item

  let output_directory = "dist/" <> route <> "/" <> slug
  let item_shortcodes = [
    Shortcode(
      marker: "{{ featured-image }}",
      html: components.featured_image(item),
    ),
    ..shortcodes
  ]

  let item_html =
    markdown
    |> content.expand_shortcodes(item_shortcodes)
    |> mork.parse
    |> mork.to_html

  let page_content =
    "<article class='item-content'>"
    <> components.item_meta(route, item_label, published)
    <> components.tag_list(tags)
    <> item_html
    <> "</article>"

  let path = "/" <> route <> "/" <> slug <> "/"

  let Item(featured_image:, indexable:, ..) = item
  let social_image = case featured_image {
    Some(FeaturedImage(src:, ..)) -> src
    None -> "/assets/og.png"
  }

  let html =
    site.page(
      site.Metadata(
        title:,
        description:,
        path:,
        image: social_image,
        page_type: "article",
        indexable:,
      ),
      page_content,
    )

  let assert Ok(Nil) = simplifile.create_directory_all(output_directory)
  let assert Ok(Nil) =
    simplifile.write(to: output_directory <> "/index.html", contents: html)
  Nil
}

// Tags

pub fn build_tags(loaded_collections: List(LoadedCollection)) -> Nil {
  let tagged_items = indexable_tagged_items(loaded_collections)
  let tags = tag_names(tagged_items)

  build_tag_index(tags, tagged_items)
  list.each(tags, build_tag_page(_, tagged_items))
}

fn build_tag_index(tags: List(String), tagged_items: List(TaggedItem)) -> Nil {
  let tag_links =
    tags
    |> list.map(fn(tag) {
      let matching_item_count =
        tagged_items
        |> list.filter(fn(tagged_item) {
          let TaggedItem(item: Item(tags:, ..), ..) = tagged_item
          list.contains(tags, tag)
        })
        |> list.length

      "<a href='/tags/"
      <> collections.tag_slug(tag)
      <> "/'><span>"
      <> site.escape_html(tag)
      <> "</span><small>"
      <> int.to_string(matching_item_count)
      <> case matching_item_count {
        1 -> " item"
        _ -> " items"
      }
      <> "</small></a>"
    })
    |> string.join("\n")

  let page_content = "<section class='tag-heading'>
      <p class='eyebrow'>Topics</p>
      <h1>Tag index</h1>
      <p>Browse the vocabulary already in use across every Docklands collection.</p>
    </section>
    <div class='tag-index'>" <> tag_links <> "</div>"

  let html =
    site.page(
      site.Metadata(
        title: "Tags — Docklands",
        description: "Browse every topic used across Docklands guides and notes.",
        path: "/tags/",
        image: "/assets/og.png",
        page_type: "website",
        indexable: True,
      ),
      page_content,
    )

  let assert Ok(Nil) = simplifile.create_directory_all("dist/tags")
  let assert Ok(Nil) =
    simplifile.write(to: "dist/tags/index.html", contents: html)
  Nil
}

fn build_tag_page(tag: String, tagged_items: List(TaggedItem)) -> Nil {
  let matching_items =
    tagged_items
    |> list.filter(fn(tagged_item) {
      let TaggedItem(item: Item(tags:, ..), ..) = tagged_item
      list.contains(tags, tag)
    })

  let card_items =
    matching_items
    |> list.map(fn(tagged_item) {
      let TaggedItem(route:, item_label:, item:) = tagged_item
      #(route, item_label, item)
    })

  let title = tag <> " — Tagged content"
  let description = "Guides and notes tagged “" <> tag <> "” in Docklands."
  let path = "/tags/" <> collections.tag_slug(tag) <> "/"
  let page_content = "<section class='tag-heading'>
      <p class='eyebrow'>Tag</p>
      <h1>" <> site.escape_html(tag) <> "</h1>
      <p>Everything published with this tag, across every Docklands collection.</p>
    </section>" <> components.tagged_item_list(card_items)

  let html =
    site.page(
      site.Metadata(
        title:,
        description:,
        path:,
        image: "/assets/og.png",
        page_type: "website",
        indexable: True,
      ),
      page_content,
    )

  let output_directory = "dist/tags/" <> collections.tag_slug(tag)
  let assert Ok(Nil) = simplifile.create_directory_all(output_directory)
  let assert Ok(Nil) =
    simplifile.write(to: output_directory <> "/index.html", contents: html)
  Nil
}

fn indexable_tagged_items(
  loaded_collections: List(LoadedCollection),
) -> List(TaggedItem) {
  loaded_collections
  |> list.flat_map(fn(loaded_collection) {
    let LoadedCollection(
      collection: Collection(route:, item_label:, ..),
      items:,
    ) = loaded_collection

    items
    |> list.filter(fn(item) {
      let Item(indexable:, ..) = item
      indexable
    })
    |> list.map(fn(item) { TaggedItem(route:, item_label:, item:) })
  })
}

fn tag_names(tagged_items: List(TaggedItem)) -> List(String) {
  tagged_items
  |> list.flat_map(fn(tagged_item) {
    let TaggedItem(item: Item(tags:, ..), ..) = tagged_item
    tags
  })
  |> list.unique
  |> list.sort(string.compare)
}

// Discovery files

pub fn write_discovery_files(
  route_sources: List(String),
  loaded_collections: List(LoadedCollection),
) -> Nil {
  let route_urls =
    route_sources
    |> list.filter(fn(source) {
      let assert Ok(source_markdown) = simplifile.read(from: source)

      let Document(indexable:, ..) = content.parse_document(source_markdown)

      let path = route_path(route_relative_path(source))
      indexable && route_is_indexable(path, loaded_collections)
    })
    |> list.map(fn(source) { route_path(route_relative_path(source)) })
    |> list.map(sitemap_url(_, None))

  let item_urls =
    loaded_collections
    |> list.flat_map(fn(loaded_collection) {
      let LoadedCollection(collection: Collection(route:, ..), items:) =
        loaded_collection

      items
      |> list.filter(fn(item) {
        let Item(indexable:, ..) = item

        indexable
      })
      |> list.map(fn(item) {
        let Item(slug:, published:, ..) = item

        sitemap_url("/" <> route <> "/" <> slug <> "/", Some(published))
      })
    })

  let tag_urls =
    loaded_collections
    |> indexable_tagged_items
    |> tag_names
    |> list.map(fn(tag) {
      sitemap_url("/tags/" <> collections.tag_slug(tag) <> "/", None)
    })

  let tag_urls = [sitemap_url("/tags/", None), ..tag_urls]

  let sitemap_entries =
    [route_urls, item_urls, tag_urls]
    |> list.flatten
    |> string.join("\n")

  let sitemap =
    "<?xml version='1.0' encoding='UTF-8'?>\n"
    <> "<urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>\n"
    <> sitemap_entries
    <> "\n</urlset>\n"

  let sitemap_location = site.absolute_url("/sitemap.xml")

  let robots =
    "User-agent: *\n"
    <> "Allow: /\n\n"
    <> "Sitemap: "
    <> sitemap_location
    <> "\n"

  let assert Ok(Nil) =
    simplifile.write(to: "dist/sitemap.xml", contents: sitemap)

  let assert Ok(Nil) = simplifile.write(to: "dist/robots.txt", contents: robots)
  Nil
}

fn sitemap_url(path: String, last_modified: Option(String)) -> String {
  let last_modified_xml = case last_modified {
    None -> ""
    Some(date) -> "\n    <lastmod>" <> date <> "</lastmod>"
  }

  "  <url>\n    <loc>"
  <> site.absolute_url(path)
  <> "</loc>"
  <> last_modified_xml
  <> "\n  </url>"
}
