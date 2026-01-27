import gleam/list
import lustre/attribute.{class}
import lustre/element.{type Element, text}
import lustre/element/html.{h1, p, section, ul}
import njssg/config.{type Config}
import njssg/templates/components

/// Render the categories listing page
pub fn render(_config: Config, categories: List(#(String, Int))) -> Element(msg) {
  section([class("categories-listing")], [
    h1([class("page-title")], [text("Categories")]),
    case categories {
      [] -> p([class("no-categories")], [text("No categories yet.")])
      cats ->
        ul(
          [class("categories-list")],
          list.map(cats, fn(cat) {
            let #(name, count) = cat
            components.category_link(name, count)
          }),
        )
    },
  ])
}
