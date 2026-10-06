import collections.{FeaturedImage}
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import mork
import yamleam
import yamleam/node.{type YamlNode, YamlBool, YamlMap, YamlString}

pub type Metadata {
  Metadata(values: Dict(String, YamlNode))
}

pub type Document {
  Document(
    title: String,
    description: String,
    published: String,
    indexable: Bool,
    markdown: String,
    metadata: Metadata,
  )
}

pub type ParseError {
  InvalidYaml(yamleam.YamlError)
  FrontmatterMustBeMapping
  MissingRequiredField(String)
  RequiredFieldMustBeString(String)
  EmptyRequiredField(String)
  InvalidPublishedDate(String)
}

pub type Shortcode {
  Shortcode(marker: String, html: String)
}

pub fn parse_document(source: String) -> Result(Document, ParseError) {
  let #(frontmatter, markdown) = mork.split_frontmatter_from_input(source)

  use metadata <- result.try(parse_metadata(frontmatter))
  use title <- result.try(required_string(metadata, "title"))
  use description <- result.try(required_string(metadata, "description"))
  use published <- result.try(required_string(metadata, "published"))

  case valid_calendar_date(published) {
    False -> Error(InvalidPublishedDate(published))
    True ->
      Ok(Document(
        title:,
        description:,
        published:,
        indexable: !metadata_flag(metadata, "noindex"),
        markdown:,
        metadata:,
      ))
  }
}

fn parse_metadata(frontmatter: String) -> Result(Metadata, ParseError) {
  case yamleam.parse_raw(frontmatter) {
    Error(error) -> Error(InvalidYaml(error))
    Ok(YamlMap(entries)) -> Ok(Metadata(dict.from_list(entries)))
    Ok(_) -> Error(FrontmatterMustBeMapping)
  }
}

fn required_string(
  metadata: Metadata,
  key: String,
) -> Result(String, ParseError) {
  let Metadata(values:) = metadata

  case dict.get(values, key) {
    Error(_) -> Error(MissingRequiredField(key))
    Ok(YamlString(value)) ->
      case string.is_empty(string.trim(value)) {
        True -> Error(EmptyRequiredField(key))
        False -> Ok(value)
      }
    Ok(_) -> Error(RequiredFieldMustBeString(key))
  }
}

pub fn parse_featured_image(metadata: Metadata) {
  case metadata_string(metadata, "featured_image") {
    Error(_) -> None
    Ok(src) -> {
      let assert Ok(alt) = metadata_string(metadata, "featured_alt")

      Some(FeaturedImage(src:, alt:))
    }
  }
}

pub fn metadata_string(metadata: Metadata, key: String) -> Result(String, Nil) {
  let Metadata(values:) = metadata

  case dict.get(values, key) {
    Ok(YamlString(value)) -> Ok(value)
    _ -> Error(Nil)
  }
}

pub fn metadata_list(metadata: Metadata, key: String) -> List(String) {
  case metadata_string(metadata, key) {
    Error(_) -> []
    Ok(value) ->
      value
      |> string.split(",")
      |> list.map(string.trim)
      |> list.filter(fn(item) { !string.is_empty(item) })
      |> list.unique
  }
}

fn metadata_flag(metadata: Metadata, key: String) -> Bool {
  let Metadata(values:) = metadata

  case dict.get(values, key) {
    Ok(YamlBool(value)) -> value
    Ok(YamlString(value)) -> string.lowercase(value) == "true"
    _ -> False
  }
}

fn valid_calendar_date(value: String) -> Bool {
  case string.split(value, "-") {
    [year_text, month_text, day_text] ->
      case
        string.length(year_text) == 4,
        string.length(month_text) == 2,
        string.length(day_text) == 2,
        int.parse(year_text),
        int.parse(month_text),
        int.parse(day_text)
      {
        True, True, True, Ok(year), Ok(month), Ok(day) ->
          day >= 1 && day <= days_in_month(year, month)
        _, _, _, _, _, _ -> False
      }
    _ -> False
  }
}

fn days_in_month(year: Int, month: Int) -> Int {
  case month {
    1 | 3 | 5 | 7 | 8 | 10 | 12 -> 31
    4 | 6 | 9 | 11 -> 30
    2 ->
      case is_leap_year(year) {
        True -> 29
        False -> 28
      }
    _ -> 0
  }
}

fn is_leap_year(year: Int) -> Bool {
  year % 4 == 0 && { year % 100 != 0 || year % 400 == 0 }
}

pub fn expand_shortcodes(
  markdown: String,
  shortcodes: List(Shortcode),
) -> String {
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
