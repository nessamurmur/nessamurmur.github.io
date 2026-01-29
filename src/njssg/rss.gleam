import gleam/list
import gleam/option.{None, Some}
import gleam/string
import njssg/config.{type Config}
import njssg/content.{type Post}

/// Generate RSS 2.0 feed XML
pub fn generate(config: Config, posts: List(Post)) -> String {
  let channel_content =
    [
      "<title>" <> escape_xml(config.title) <> "</title>",
      "<description>" <> escape_xml(config.description) <> "</description>",
      "<link>" <> config.base_url <> "</link>",
      "<language>en-us</language>",
      "<generator>njssg</generator>",
    ]
    |> string.join("\n    ")

  let items =
    posts
    |> list.map(post_to_item(config, _))
    |> string.join("\n")

  [
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
    "<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\">",
    "  <channel>",
    "    " <> channel_content,
    "    <atom:link href=\""
      <> config.base_url
      <> "/feed.xml\" rel=\"self\" type=\"application/rss+xml\"/>",
    items,
    "  </channel>",
    "</rss>",
  ]
  |> string.join("\n")
}

fn post_to_item(config: Config, post: Post) -> String {
  let url = config.base_url <> "/posts/" <> post.slug <> "/"

  let description = case post.description {
    Some(desc) -> desc
    None -> truncate_body(post.body, 200)
  }

  let categories =
    post.categories
    |> list.map(fn(cat) {
      "      <category>" <> escape_xml(cat) <> "</category>"
    })
    |> string.join("\n")

  let category_section = case categories {
    "" -> ""
    _ -> "\n" <> categories
  }

  [
    "    <item>",
    "      <title>" <> escape_xml(post.title) <> "</title>",
    "      <link>" <> url <> "</link>",
    "      <guid isPermaLink=\"true\">" <> url <> "</guid>",
    "      <description>" <> escape_xml(description) <> "</description>",
    "      <pubDate>" <> format_rss_date(post.date) <> "</pubDate>",
    category_section,
    "    </item>",
  ]
  |> list.filter(fn(s) { s != "" })
  |> string.join("\n")
}

/// Escape special XML characters
pub fn escape_xml(text: String) -> String {
  text
  |> string.replace("&", "&amp;")
  |> string.replace("<", "&lt;")
  |> string.replace(">", "&gt;")
  |> string.replace("\"", "&quot;")
  |> string.replace("'", "&#39;")
}

/// Format date for RSS (RFC 822 format)
/// Input: "2025-01-27"
/// Output: "Mon, 27 Jan 2025 00:00:00 GMT"
fn format_rss_date(date: String) -> String {
  case string.split(date, "-") {
    [year, month, day] -> {
      let month_name = month_to_name(month)
      // For simplicity, we use a generic day name and midnight time
      "Mon, " <> day <> " " <> month_name <> " " <> year <> " 00:00:00 GMT"
    }
    _ -> date
  }
}

fn month_to_name(month: String) -> String {
  case month {
    "01" -> "Jan"
    "02" -> "Feb"
    "03" -> "Mar"
    "04" -> "Apr"
    "05" -> "May"
    "06" -> "Jun"
    "07" -> "Jul"
    "08" -> "Aug"
    "09" -> "Sep"
    "10" -> "Oct"
    "11" -> "Nov"
    "12" -> "Dec"
    _ -> month
  }
}

/// Truncate body text, stripping HTML tags
fn truncate_body(body: String, max_length: Int) -> String {
  let stripped = strip_html_tags(body)
  case string.length(stripped) > max_length {
    True -> string.slice(stripped, 0, max_length) <> "..."
    False -> stripped
  }
}

/// Simple HTML tag stripper
fn strip_html_tags(html: String) -> String {
  do_strip_html_tags(html, "", False)
}

fn do_strip_html_tags(input: String, acc: String, in_tag: Bool) -> String {
  case string.pop_grapheme(input) {
    Error(_) -> acc
    Ok(#(char, rest)) -> {
      case char, in_tag {
        "<", False -> do_strip_html_tags(rest, acc, True)
        ">", True -> do_strip_html_tags(rest, acc, False)
        _, True -> do_strip_html_tags(rest, acc, True)
        _, False -> do_strip_html_tags(rest, acc <> char, False)
      }
    }
  }
}
