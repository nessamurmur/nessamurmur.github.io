import lustre/attribute.{class}
import lustre/element.{type Element, text}
import lustre/element/html.{article, div, h1, header}
import njssg/config.{type Config}
import njssg/content.{type Page}

/// Render a static page
pub fn render(_config: Config, page: Page) -> Element(msg) {
  article([class("static-page")], [
    header([class("page-header")], [
      h1([class("page-title")], [text(page.title)]),
    ]),
    div([class("page-content prose")], [
      element.unsafe_raw_html("", "div", [], page.body),
    ]),
  ])
}
