import collections.{type Entry, Entry}
import gleam/int
import gleam/list
import gleam/string
import site

pub fn collection_list(
  route: String,
  item_label: String,
  entries: List(Entry),
) -> String {
  let cards =
    entries
    |> list.map(fn(entry) {
      let Entry(
        slug:,
        title:,
        description:,
        published:,
        featured_image:,
        featured_alt:,
        ..,
      ) = entry
      "<article class='entry-card group'>
      <a class='entry-image' href='/" <> route <> "/" <> slug <> "/' tabindex='-1'>
        <img src='" <> site.escape_html(featured_image) <> "' alt='" <> site.escape_html(
        featured_alt,
      ) <> "' loading='lazy'>
      </a>
      <div class='entry-card-copy'>
        " <> published_date(published) <> "
        <h2><a href='/" <> route <> "/" <> slug <> "/'>" <> site.escape_html(
        title,
      ) <> "</a></h2>
        <p>" <> site.escape_html(description) <> "</p>
        <a class='entry-link' href='/" <> route <> "/" <> slug <> "/'>Read " <> item_label <> " <span aria-hidden='true'>↗</span></a>
      </div>
    </article>"
    })
    |> string.join("\n")
  "<div class='collection-list'>" <> cards <> "</div>"
}

pub fn entry_meta(
  route: String,
  item_label: String,
  published: String,
) -> String {
  "<div class='entry-meta'>
    <a class='back-link' href='/" <> route <> "/'>← All " <> item_label <> "s</a>
    " <> published_date(published) <> "
  </div>"
}

pub fn featured_image(entry: Entry) -> String {
  let Entry(featured_image:, featured_alt:, ..) = entry
  "<figure class='featured-image'>
    <img src='" <> site.escape_html(featured_image) <> "' alt='" <> site.escape_html(
    featured_alt,
  ) <> "'>
  </figure>"
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
