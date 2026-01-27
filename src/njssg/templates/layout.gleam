import lustre/attribute.{attribute, charset, class, href, name, rel, type_}
import lustre/element.{type Element, text}
import lustre/element/html.{body, div, head, html, link, meta, title}
import njssg/config.{type Config}
import njssg/templates/components

/// Render a page with the base layout
pub fn render(
  config: Config,
  page_title: String,
  page_content: Element(msg),
) -> Element(msg) {
  html([attribute("lang", "en")], [
    head([], [
      meta([charset("utf-8")]),
      meta([
        name("viewport"),
        attribute("content", "width=device-width, initial-scale=1.0"),
      ]),
      meta([name("description"), attribute("content", config.description)]),
      meta([name("author"), attribute("content", config.author)]),
      title([], page_title <> " | " <> config.title),
      link([rel("stylesheet"), href("/css/style.css")]),
      case config.rss.enabled {
        True ->
          link([
            rel("alternate"),
            type_("application/rss+xml"),
            attribute("title", config.title <> " RSS Feed"),
            href("/feed.xml"),
          ])
        False -> text("")
      },
    ]),
    body([class("min-h-screen bg-gray-50")], [
      components.site_nav(config),
      div([class("main-content container mx-auto px-4 py-8")], [page_content]),
      components.site_footer(config),
    ]),
  ])
}

/// Convert element to full HTML string with doctype
pub fn to_html_string(el: Element(msg)) -> String {
  "<!DOCTYPE html>\n" <> element.to_string(el)
}
