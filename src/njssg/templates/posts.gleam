import gleam/list
import lustre/attribute.{class}
import lustre/element.{type Element, text}
import lustre/element/html.{div, h1, p, section}
import njssg/config.{type Config}
import njssg/content.{type Post}
import njssg/templates/components

/// Render the posts listing page with pagination
pub fn render(
  _config: Config,
  posts: List(Post),
  current_page: Int,
  total_pages: Int,
) -> Element(msg) {
  section([class("posts-listing")], [
    h1([class("page-title")], [text("Posts")]),
    case posts {
      [] -> p([class("no-posts")], [text("No posts yet.")])
      _ ->
        div([class("posts-grid")], list.map(posts, components.post_card))
    },
    components.pagination(current_page, total_pages),
  ])
}
