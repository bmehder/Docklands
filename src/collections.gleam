import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/uri
import output

// Content types

pub type FeaturedImage {
  FeaturedImage(src: String, alt: String)
}

pub type Item {
  Item(
    slug: String,
    title: String,
    description: String,
    published: String,
    publication_order: Int,
    series_label: Option(String),
    tags: List(String),
    featured_image: Option(FeaturedImage),
    indexable: Bool,
    markdown: String,
  )
}

// Tags

pub fn tag_slug(tag: String) -> String {
  tag
  |> string.trim
  |> string.lowercase
  |> string.replace(" ", "-")
  |> uri.percent_encode
}

pub fn tag_list(tags: List(String)) -> String {
  case tags {
    [] -> ""
    _ -> {
      let links =
        tags
        |> list.map(fn(tag) {
          "<a href='/tags/"
          <> tag_slug(tag)
          <> "/'>"
          <> output.escape_html(tag)
          <> "</a>"
        })
        |> string.join("\n")

      "<div class='tag-list' aria-label='Tags'>" <> links <> "</div>"
    }
  }
}

// Collection listings

pub fn collection_list(
  route: String,
  item_label: String,
  items: List(Item),
) -> String {
  let cards =
    items
    |> list.map(fn(item) { item_card(route, item_label, item) })
    |> string.join("\n")

  "<div class='collection-list'>" <> cards <> "</div>"
}

pub fn tagged_item_list(items: List(#(String, String, Item))) -> String {
  let cards =
    items
    |> list.map(fn(tagged_item) {
      let #(route, item_label, item) = tagged_item
      item_card(route, item_label, item)
    })
    |> string.join("\n")

  "<div class='collection-list'>" <> cards <> "</div>"
}

fn item_card(route: String, item_label: String, card_item: Item) -> String {
  let Item(slug:, title:, description:, published:, featured_image:, ..) =
    card_item

  let image = case featured_image {
    Some(FeaturedImage(src:, alt:)) ->
      "<a class='item-image' href='/"
      <> route
      <> "/"
      <> slug
      <> "/' tabindex='-1'>
        <img src='"
      <> output.escape_html(src)
      <> "' alt='"
      <> output.escape_html(alt)
      <> "' loading='lazy'>
      </a>"
    None -> "<!-- No featured image -->"
  }

  "<article class='item-card group'>
      " <> image <> "
      <div class='item-card-copy'>
        " <> published_date(published) <> series_label(card_item) <> "
        <h2><a href='/" <> route <> "/" <> slug <> "/'>" <> output.escape_html(
    title,
  ) <> "</a></h2>
        <p>" <> output.escape_html(description) <> "</p>
        " <> tag_list(card_item.tags) <> "
        <a class='item-link' href='/" <> route <> "/" <> slug <> "/'>Read " <> item_label <> " <span aria-hidden='true'>↗</span></a>
      </div>
    </article>"
}

fn series_label(card_item: Item) -> String {
  case card_item.series_label {
    Some(label) ->
      "<p class='series-label'>" <> output.escape_html(label) <> "</p>"
    None -> ""
  }
}

// Item pages

pub fn item_meta(
  route: String,
  item_label: String,
  published: String,
) -> String {
  "<div class='item-meta'>
    <a class='back-link' href='/" <> route <> "/'>← All " <> item_label <> "s</a>
    " <> published_date(published) <> "
  </div>"
}

pub fn featured_image(item: Item) -> String {
  let Item(featured_image:, ..) = item

  case featured_image {
    Some(FeaturedImage(src:, alt:)) -> "<figure class='featured-image'>
    <img src='" <> output.escape_html(src) <> "' alt='" <> output.escape_html(
        alt,
      ) <> "'>
  </figure>"
    None -> ""
  }
}

fn published_date(published: String) -> String {
  "<p class='published-date'><time datetime='"
  <> output.escape_html(published)
  <> "'>"
  <> format_date(published)
  <> "</time></p>"
}

fn format_date(published: String) -> String {
  let assert [year, month, day] = string.split(published, on: "-")
  let assert Ok(day) = int.parse(day)
  let month = case month {
    "01" -> "January"
    "02" -> "February"
    "03" -> "March"
    "04" -> "April"
    "05" -> "May"
    "06" -> "June"
    "07" -> "July"
    "08" -> "August"
    "09" -> "September"
    "10" -> "October"
    "11" -> "November"
    "12" -> "December"
    _ -> month
  }

  int.to_string(day) <> " " <> month <> " " <> year
}
