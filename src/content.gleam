import collections.{type FeaturedImage, FeaturedImage}
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import mork
import yamleam
import yamleam/node.{type YamlNode, YamlBool, YamlInt, YamlMap, YamlString}

// Document and frontmatter types

pub type Frontmatter {
  Frontmatter(values: Dict(String, YamlNode))
}

pub type Document {
  Document(
    title: String,
    description: String,
    published: String,
    indexable: Bool,
    markdown: String,
    frontmatter: Frontmatter,
  )
}

pub type ParseError {
  InvalidYaml(yamleam.YamlError)
  FrontmatterMustBeMapping
  MissingRequiredField(String)
  RequiredFieldMustBeString(String)
  EmptyRequiredField(String)
  OptionalFieldMustBeString(String)
  OptionalFieldMustBeInteger(String)
  OptionalFieldMustBeBoolean(String)
  EmptyOptionalField(String)
  FeaturedImageRequiresAlt
  FeaturedAltRequiresImage
  InvalidPublishedDate(String)
}

// Required frontmatter and document parsing

pub fn parse_document(source: String) -> Result(Document, ParseError) {
  let #(frontmatter, markdown) = mork.split_frontmatter_from_input(source)

  use frontmatter <- result.try(parse_frontmatter(frontmatter))
  use title <- result.try(required_string(frontmatter, "title"))
  use description <- result.try(required_string(frontmatter, "description"))
  use published <- result.try(required_string(frontmatter, "published"))
  use noindex <- result.try(frontmatter_flag(frontmatter, "noindex"))

  case valid_calendar_date(published) {
    False -> Error(InvalidPublishedDate(published))
    True ->
      Ok(Document(
        title:,
        description:,
        published:,
        indexable: !noindex,
        markdown:,
        frontmatter:,
      ))
  }
}

fn parse_frontmatter(frontmatter: String) -> Result(Frontmatter, ParseError) {
  case yamleam.parse_raw(frontmatter) {
    Error(error) -> Error(InvalidYaml(error))
    Ok(YamlMap(entries)) -> Ok(Frontmatter(dict.from_list(entries)))
    Ok(_) -> Error(FrontmatterMustBeMapping)
  }
}

fn required_string(
  frontmatter: Frontmatter,
  key: String,
) -> Result(String, ParseError) {
  let Frontmatter(values:) = frontmatter

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

// Optional collection frontmatter

pub fn parse_featured_image(
  frontmatter: Frontmatter,
) -> Result(Option(FeaturedImage), ParseError) {
  use src <- result.try(optional_string(frontmatter, "featured_image"))
  use alt <- result.try(optional_string(frontmatter, "featured_alt"))

  case src, alt {
    None, None -> Ok(None)
    Some(src), Some(alt) -> Ok(Some(FeaturedImage(src:, alt:)))
    Some(_), None -> Error(FeaturedImageRequiresAlt)
    None, Some(_) -> Error(FeaturedAltRequiresImage)
  }
}

pub fn optional_string(
  frontmatter: Frontmatter,
  key: String,
) -> Result(Option(String), ParseError) {
  let Frontmatter(values:) = frontmatter

  case dict.get(values, key) {
    Error(_) -> Ok(None)
    Ok(YamlString(value)) ->
      case string.is_empty(string.trim(value)) {
        True -> Error(EmptyOptionalField(key))
        False -> Ok(Some(value))
      }
    Ok(_) -> Error(OptionalFieldMustBeString(key))
  }
}

pub fn publication_order(frontmatter: Frontmatter) -> Result(Int, ParseError) {
  let Frontmatter(values:) = frontmatter

  case dict.get(values, "publication_order") {
    Error(_) -> Ok(0)
    Ok(YamlInt(value)) -> Ok(value)
    Ok(YamlString(value)) ->
      case int.parse(value) {
        Ok(order) -> Ok(order)
        Error(_) -> Error(OptionalFieldMustBeInteger("publication_order"))
      }
    Ok(_) -> Error(OptionalFieldMustBeInteger("publication_order"))
  }
}

pub fn frontmatter_list(
  frontmatter: Frontmatter,
  key: String,
) -> Result(List(String), ParseError) {
  use value <- result.try(optional_string(frontmatter, key))

  case value {
    None -> Ok([])
    Some(value) ->
      value
      |> string.split(",")
      |> list.map(string.trim)
      |> list.filter(fn(item) { !string.is_empty(item) })
      |> list.unique
      |> Ok
  }
}

fn frontmatter_flag(
  frontmatter: Frontmatter,
  key: String,
) -> Result(Bool, ParseError) {
  let Frontmatter(values:) = frontmatter

  case dict.get(values, key) {
    Error(_) -> Ok(False)
    Ok(YamlBool(value)) -> Ok(value)
    Ok(YamlString(value)) ->
      case string.lowercase(string.trim(value)) {
        "true" -> Ok(True)
        "false" -> Ok(False)
        _ -> Error(OptionalFieldMustBeBoolean(key))
      }
    Ok(_) -> Error(OptionalFieldMustBeBoolean(key))
  }
}

// Calendar-date validation

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
