import gleam/list
import lustre/attribute.{class}
import lustre/element.{type Element, text}
import lustre/element/html.{div, h1, p, section}
import njssg/config.{type Config}
import njssg/content.{type Post}
import njssg/templates/components

/// Render posts for a single category
pub fn render(_config: Config, category: String, posts: List(Post)) -> Element(msg) {
  section([class("category-posts")], [
    h1([class("page-title")], [text("Category: " <> category)]),
    case posts {
      [] -> p([class("no-posts")], [text("No posts in this category.")])
      _ -> div([class("posts-grid")], list.map(posts, components.post_card))
    },
  ])
}
