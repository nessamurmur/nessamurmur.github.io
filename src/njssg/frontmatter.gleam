import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import tom

/// Frontmatter for blog posts
pub type Frontmatter {
  Frontmatter(
    title: String,
    date: String,
    categories: List(String),
    description: Option(String),
    draft: Bool,
  )
}

/// Frontmatter for static pages (simpler than posts)
pub type PageFrontmatter {
  PageFrontmatter(title: String, description: Option(String))
}

pub type FrontmatterError {
  MissingDelimiter
  ParseError(String)
  MissingField(String)
}

const delimiter = "+++"

/// Parse post frontmatter and return (frontmatter, body)
pub fn parse(content: String) -> Result(#(Frontmatter, String), FrontmatterError) {
  use #(toml_str, body) <- result.try(extract_frontmatter(content))
  use parsed <- result.try(
    tom.parse(toml_str)
    |> result.map_error(fn(_) { ParseError("Invalid TOML in frontmatter") }),
  )

  use title <- result.try(
    tom.get_string(parsed, ["title"])
    |> result.map_error(fn(_) { MissingField("title") }),
  )

  use date <- result.try(
    tom.get_string(parsed, ["date"])
    |> result.map_error(fn(_) { MissingField("date") }),
  )

  let categories = case tom.get_array(parsed, ["categories"]) {
    Ok(arr) ->
      list.filter_map(arr, fn(item) {
        case item {
          tom.String(s) -> Ok(s)
          _ -> Error(Nil)
        }
      })
    Error(_) -> []
  }

  let description = case tom.get_string(parsed, ["description"]) {
    Ok(s) -> Some(s)
    Error(_) -> None
  }

  let draft = case tom.get_bool(parsed, ["draft"]) {
    Ok(b) -> b
    Error(_) -> False
  }

  Ok(#(
    Frontmatter(
      title: title,
      date: date,
      categories: categories,
      description: description,
      draft: draft,
    ),
    body,
  ))
}

/// Parse page frontmatter (simpler - only title required)
pub fn parse_page(
  content: String,
) -> Result(#(PageFrontmatter, String), FrontmatterError) {
  use #(toml_str, body) <- result.try(extract_frontmatter(content))
  use parsed <- result.try(
    tom.parse(toml_str)
    |> result.map_error(fn(_) { ParseError("Invalid TOML in frontmatter") }),
  )

  use title <- result.try(
    tom.get_string(parsed, ["title"])
    |> result.map_error(fn(_) { MissingField("title") }),
  )

  let description = case tom.get_string(parsed, ["description"]) {
    Ok(s) -> Some(s)
    Error(_) -> None
  }

  Ok(#(PageFrontmatter(title: title, description: description), body))
}

/// Extract the TOML content between +++ delimiters and return (toml, body)
fn extract_frontmatter(content: String) -> Result(#(String, String), FrontmatterError) {
  let trimmed = string.trim_start(content)

  case string.starts_with(trimmed, delimiter) {
    False -> Error(MissingDelimiter)
    True -> {
      let after_start = string.drop_start(trimmed, string.length(delimiter))

      case string.split_once(after_start, delimiter) {
        Error(_) -> Error(MissingDelimiter)
        Ok(#(toml_content, body)) -> Ok(#(string.trim(toml_content), body))
      }
    }
  }
}
