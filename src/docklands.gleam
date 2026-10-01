import collections.{type Collection, type Item, Collection, FeaturedImage, Item}
import components
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import mork
import simplifile
import site

const routes_directory = "content/routes"

type Document {
  Document(
    title: String,
    description: String,
    indexable: Bool,
    markdown: String,
  )
}

type LoadedCollection {
  LoadedCollection(collection: Collection, items: List(Item))
}

type Shortcode {
  Shortcode(marker: String, html: String)
}

type TaggedItem {
  TaggedItem(route: String, item_label: String, item: Item)
}

pub fn main() -> Nil {
  prepare_output()

  let loaded_collections = collections.all() |> list.map(load_collection)
  let shortcodes = loaded_collections |> list.map(collection_shortcode)
  let tag_count =
    loaded_collections
    |> indexable_tagged_items
    |> tag_names
    |> list.length

  let route_sources = load_routes()

  list.each(route_sources, build_route(_, shortcodes, loaded_collections))
  list.each(loaded_collections, build_collection(_, shortcodes))
  build_tag_pages(loaded_collections)
  write_discovery_files(route_sources, loaded_collections)
  copy_static_assets()

  io.println(
    "Generated "
    <> int.to_string(list.length(route_sources))
    <> " routes, "
    <> int.to_string(item_count(loaded_collections))
    <> " collection items, "
    <> int.to_string(tag_count)
    <> " tag archives, a tag index, and static assets in dist/",
  )
}

// Output setup

fn prepare_output() -> Nil {
  let assert Ok(Nil) = simplifile.create_directory_all("dist")
  let assert Ok(Nil) = simplifile.clear_directory(at: "dist")
  Nil
}

fn copy_static_assets() -> Nil {
  let assert Ok(Nil) =
    simplifile.copy_directory(at: "assets/static", to: "dist/assets")
  Nil
}

fn item_count(loaded_collections: List(LoadedCollection)) -> Int {
  loaded_collections
  |> list.fold(0, fn(total, loaded_collection) {
    let LoadedCollection(items:, ..) = loaded_collection
    total + list.length(items)
  })
}

// Routes

fn load_routes() -> List(String) {
  let assert Ok(files) = simplifile.get_files(in: routes_directory)

  files
  |> list.filter(string.ends_with(_, ".md"))
  |> list.sort(string.compare)
}

fn build_route(
  source_path: String,
  shortcodes: List(Shortcode),
  loaded_collections: List(LoadedCollection),
) -> Nil {
  let assert Ok(source_markdown) = simplifile.read(from: source_path)

  let Document(title:, description:, indexable:, markdown:) =
    parse_document(source_markdown)

  let relative_path = route_relative_path(source_path)
  let output_path = "dist/" <> string.drop_end(relative_path, 3) <> ".html"
  let output_directory = output_directory(output_path)

  let content =
    markdown
    |> expand_shortcodes(shortcodes)
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
      content,
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
    parse_document(source_markdown)

  let #(frontmatter, _) = mork.split_frontmatter_from_input(source_markdown)

  let assert Ok(published) = frontmatter_value(frontmatter, "published")
  let tags = frontmatter_list(frontmatter, "tags")
  let featured_image = parse_featured_image(frontmatter)

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
    |> expand_shortcodes(item_shortcodes)
    |> mork.parse
    |> mork.to_html

  let content =
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
      content,
    )

  let assert Ok(Nil) = simplifile.create_directory_all(output_directory)
  let assert Ok(Nil) =
    simplifile.write(to: output_directory <> "/index.html", contents: html)
  Nil
}

// Tags

fn build_tag_pages(loaded_collections: List(LoadedCollection)) -> Nil {
  let tagged_items = indexable_tagged_items(loaded_collections)
  let tags = tag_names(tagged_items)

  build_tag_index(tags, tagged_items)
  list.each(tags, build_tag_page(_, tagged_items))
}

fn build_tag_index(tags: List(String), tagged_items: List(TaggedItem)) -> Nil {
  let tag_links =
    tags
    |> list.map(fn(tag) {
      let item_count =
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
      <> int.to_string(item_count)
      <> case item_count {
        1 -> " item"
        _ -> " items"
      }
      <> "</small></a>"
    })
    |> string.join("\n")

  let content = "<section class='tag-heading'>
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
      content,
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
  let content = "<section class='tag-heading'>
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
      content,
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

fn write_discovery_files(
  route_sources: List(String),
  loaded_collections: List(LoadedCollection),
) -> Nil {
  let route_urls =
    route_sources
    |> list.filter(fn(source) {
      let assert Ok(contents) = simplifile.read(from: source)

      let Document(indexable:, ..) = parse_document(contents)

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

// Markdown and frontmatter

fn parse_document(source: String) -> Document {
  let #(frontmatter, markdown) = mork.split_frontmatter_from_input(source)

  let assert Ok(title) = frontmatter_value(frontmatter, "title")
  let assert Ok(description) = frontmatter_value(frontmatter, "description")

  let indexable = !frontmatter_flag(frontmatter, "noindex")

  Document(title:, description:, indexable:, markdown:)
}

fn parse_featured_image(frontmatter: String) {
  case frontmatter_value(frontmatter, "featured_image") {
    Error(_) -> None
    Ok(src) -> {
      let assert Ok(alt) = frontmatter_value(frontmatter, "featured_alt")

      Some(FeaturedImage(src:, alt:))
    }
  }
}

fn frontmatter_value(frontmatter: String, key: String) -> Result(String, Nil) {
  frontmatter
  |> string.split("\n")
  |> list.find_map(fn(line) {
    case string.split_once(line, on: ":") {
      Ok(#(found_key, value)) ->
        case string.trim(found_key) == key {
          True -> Ok(string.trim(value))
          False -> Error(Nil)
        }
      _ -> Error(Nil)
    }
  })
}

fn frontmatter_flag(frontmatter: String, key: String) -> Bool {
  case frontmatter_value(frontmatter, key) {
    Ok(value) -> string.lowercase(value) == "true"
    Error(_) -> False
  }
}

fn frontmatter_list(frontmatter: String, key: String) -> List(String) {
  case frontmatter_value(frontmatter, key) {
    Error(_) -> []
    Ok(value) ->
      value
      |> string.split(",")
      |> list.map(string.trim)
      |> list.filter(fn(item) { !string.is_empty(item) })
      |> list.unique
  }
}

// Shortcodes

fn expand_shortcodes(markdown: String, shortcodes: List(Shortcode)) -> String {
  markdown
  |> string.split("\n")
  |> expand_shortcode_lines(shortcodes, False)
  |> string.join("\n")
}

fn expand_shortcode_lines(
  lines: List(String),
  shortcodes: List(Shortcode),
  in_code_block: Bool,
) -> List(String) {
  case lines {
    [] -> []
    [line, ..rest] -> {
      let trimmed_line = string.trim(line)

      case string.starts_with(trimmed_line, "```") {
        True -> [
          line,
          ..expand_shortcode_lines(rest, shortcodes, !in_code_block)
        ]
        False -> {
          let expanded_line = case in_code_block {
            True -> line
            False -> expand_shortcode_line(line, trimmed_line, shortcodes)
          }

          [
            expanded_line,
            ..expand_shortcode_lines(rest, shortcodes, in_code_block)
          ]
        }
      }
    }
  }
}

fn expand_shortcode_line(
  line: String,
  trimmed_line: String,
  shortcodes: List(Shortcode),
) -> String {
  case
    list.find_map(shortcodes, fn(shortcode) {
      let Shortcode(marker:, html:) = shortcode

      case trimmed_line == marker {
        True -> Ok(html)
        False -> Error(Nil)
      }
    })
  {
    Ok(html) -> html
    Error(_) -> line
  }
}
