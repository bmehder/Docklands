import config
import gleam/string

pub fn absolute_url(reference: String) -> String {
  case
    string.starts_with(reference, "https://")
    || string.starts_with(reference, "http://")
  {
    True -> reference
    False -> {
      let assert True = string.starts_with(reference, "/")
      config.base_url <> reference
    }
  }
}

pub fn escape_html(value: String) -> String {
  value
  |> string.replace("&", "&amp;")
  |> string.replace("<", "&lt;")
  |> string.replace(">", "&gt;")
  |> string.replace("'", "&#39;")
  |> string.replace("\"", "&quot;")
}
