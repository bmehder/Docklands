import collections.{type Item, FeaturedImage, Item}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import site

pub fn collection_list(
  route: String,
  item_label: String,
  items: List(Item),
) -> String {
  let cards =
    items
    |> list.map(item_card(route, item_label, _))
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

fn item_card(route: String, item_label: String, item: Item) -> String {
  let Item(slug:, title:, description:, published:, tags:, featured_image:, ..) =
    item

  let image = case featured_image {
    Some(FeaturedImage(src:, alt:)) ->
      "<a class='item-image' href='/"
      <> route
      <> "/"
      <> slug
      <> "/' tabindex='-1'>
        <img src='"
      <> site.escape_html(src)
      <> "' alt='"
      <> site.escape_html(alt)
      <> "' loading='lazy'>
      </a>"
    None -> "<!-- No featured image -->"
  }

  "<article class='item-card group'>
      " <> image <> "
      <div class='item-card-copy'>
        " <> published_date(published) <> "
        <h2><a href='/" <> route <> "/" <> slug <> "/'>" <> site.escape_html(
    title,
  ) <> "</a></h2>
        <p>" <> site.escape_html(description) <> "</p>
        " <> tag_list(tags) <> "
        <a class='item-link' href='/" <> route <> "/" <> slug <> "/'>Read " <> item_label <> " <span aria-hidden='true'>↗</span></a>
      </div>
    </article>"
}

pub fn tag_list(tags: List(String)) -> String {
  case tags {
    [] -> ""
    _ -> {
      let links =
        tags
        |> list.map(fn(tag) {
          "<a href='/tags/"
          <> collections.tag_slug(tag)
          <> "/'>"
          <> site.escape_html(tag)
          <> "</a>"
        })
        |> string.join("\n")

      "<div class='tag-list' aria-label='Tags'>" <> links <> "</div>"
    }
  }
}

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
    <img src='" <> site.escape_html(src) <> "' alt='" <> site.escape_html(alt) <> "'>
  </figure>"
    None -> ""
  }
}

fn published_date(published: String) -> String {
  "<p class='published-date'><time datetime='"
  <> site.escape_html(published)
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
