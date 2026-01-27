import gleam/result
import gleam/string
import lustre/element.{type Element}
import mork
import mork/to_lustre
import njssg/content.{type Page, type Post, Page, Post}
import njssg/frontmatter

/// Render markdown to HTML string
pub fn render_to_string(markdown: String) -> String {
  markdown
  |> mork.parse
  |> mork.to_html
}

/// Render markdown to Lustre element
pub fn render_to_lustre(markdown: String) -> Element(msg) {
  markdown
  |> mork.parse
  |> to_lustre.to_lustre
  |> element.fragment
}

/// Load a post from markdown content with frontmatter
pub fn load_post(
  slug: String,
  content: String,
) -> Result(Post, frontmatter.FrontmatterError) {
  use #(fm, body) <- result.try(frontmatter.parse(content))

  let html_body = render_to_string(string.trim(body))

  Ok(Post(
    slug: slug,
    title: fm.title,
    date: fm.date,
    categories: fm.categories,
    description: fm.description,
    draft: fm.draft,
    body: html_body,
  ))
}

/// Load a page from markdown content with frontmatter
pub fn load_page(
  slug: String,
  content: String,
) -> Result(Page, frontmatter.FrontmatterError) {
  use #(fm, body) <- result.try(frontmatter.parse_page(content))

  let html_body = render_to_string(string.trim(body))

  Ok(Page(
    slug: slug,
    title: fm.title,
    description: fm.description,
    body: html_body,
  ))
}
