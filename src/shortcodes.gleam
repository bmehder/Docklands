//// Expands named, line-oriented markers before Markdown is rendered.
////
//// Shortcodes deliberately remain a small replacement mechanism rather than
//// becoming a general template language.

import gleam/list
import gleam/string

/// Associates a standalone Markdown marker with a reusable HTML fragment.
pub type Shortcode {
  Shortcode(marker: String, html: String)
}

type CodeBlockState {
  OutsideCodeBlock
  InsideCodeBlock
}

/// Replaces shortcode markers that occupy an entire Markdown line.
///
/// Markers inside fenced code blocks remain literal so documentation can show
/// shortcode syntax without accidentally rendering the associated HTML.
pub fn expand(markdown: String, shortcodes: List(Shortcode)) -> String {
  markdown
  |> string.split("\n")
  |> expand_lines(shortcodes, OutsideCodeBlock)
  |> string.join("\n")
}

fn expand_lines(
  lines: List(String),
  shortcodes: List(Shortcode),
  code_block_state: CodeBlockState,
) -> List(String) {
  case lines {
    [] -> []
    [line, ..rest] -> {
      let trimmed_line = string.trim(line)

      case string.starts_with(trimmed_line, "```") {
        True -> [
          line,
          ..expand_lines(
            rest,
            shortcodes,
            next_code_block_state(code_block_state),
          )
        ]
        False -> {
          let expanded_line = case code_block_state {
            InsideCodeBlock -> line
            OutsideCodeBlock -> expand_line(line, trimmed_line, shortcodes)
          }

          [expanded_line, ..expand_lines(rest, shortcodes, code_block_state)]
        }
      }
    }
  }
}

fn next_code_block_state(code_block_state: CodeBlockState) -> CodeBlockState {
  case code_block_state {
    OutsideCodeBlock -> InsideCodeBlock
    InsideCodeBlock -> OutsideCodeBlock
  }
}

fn expand_line(
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
