import gleam/list
import lustre/attribute.{class, href}
import lustre/element.{type Element, text}
import lustre/element/html.{a, div, h1, p, section}
import njssg/config.{type Config}
import njssg/content.{type Post}
import njssg/templates/components

/// Render the home page
pub fn render(config: Config, recent_posts: List(Post)) -> Element(msg) {
  div([class("home-page")], [
    section([class("hero")], [
      h1([class("hero-title")], [text(config.title)]),
      p([class("hero-description")], [text(config.description)]),
    ]),
    section([class("recent-posts")], [
      components.section_header("Recent Posts"),
      div(
        [class("posts-grid")],
        list.map(recent_posts, components.post_card),
      ),
      case recent_posts != [] {
        True ->
          div([class("view-all")], [
            a([href("/posts/"), class("view-all-link")], [text("View all posts →")]),
          ])
        False ->
          p([class("no-posts")], [text("No posts yet.")])
      },
    ]),
  ])
}
