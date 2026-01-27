import gleam/list
import lustre/attribute.{attribute, class, href}
import lustre/element.{type Element, text}
import lustre/element/html.{a, article, div, h1, header, time}
import njssg/config.{type Config}
import njssg/content.{type Post, category_url}

/// Render a single post page
pub fn render(_config: Config, post: Post) -> Element(msg) {
  article([class("post-page")], [
    header([class("post-header")], [
      h1([class("post-title")], [text(post.title)]),
      div([class("post-meta")], [
        time(
          [class("post-date"), attribute("datetime", post.date)],
          [text(post.date)],
        ),
        case post.categories {
          [] -> text("")
          cats ->
            div(
              [class("post-categories")],
              list.map(cats, fn(cat) {
                a([href(category_url(cat)), class("category-tag")], [text(cat)])
              }),
            )
        },
      ]),
    ]),
    div([class("post-content prose")], [
      element.unsafe_raw_html("", "div", [], post.body),
    ]),
  ])
}
