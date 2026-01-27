import gleam/int
import gleam/list
import gleam/option.{None, Some}
import lustre/attribute.{class, href}
import lustre/element.{type Element, text}
import lustre/element/html
import njssg/config.{type Config}
import njssg/content.{type Post, category_url, post_url}

/// Site navigation
pub fn site_nav(config: Config) -> Element(msg) {
  let links =
    config.nav.links
    |> list.map(fn(link) {
      html.li([], [html.a([href(link.url), class("nav-link")], [text(link.title)])])
    })

  html.nav([class("site-nav")], [
    html.div([class("nav-container")], [
      html.a([href("/"), class("site-title")], [text(config.title)]),
      html.ul([class("nav-links")], links),
    ]),
  ])
}

/// Site footer
pub fn site_footer(config: Config) -> Element(msg) {
  let social_links = case config.social.github, config.social.linkedin {
    Some(gh), Some(li) -> [
      html.a(
        [href("https://github.com/" <> gh), class("social-link")],
        [text("GitHub")],
      ),
      html.a(
        [href("https://linkedin.com/in/" <> li), class("social-link")],
        [text("LinkedIn")],
      ),
    ]
    Some(gh), None -> [
      html.a(
        [href("https://github.com/" <> gh), class("social-link")],
        [text("GitHub")],
      ),
    ]
    None, Some(li) -> [
      html.a(
        [href("https://linkedin.com/in/" <> li), class("social-link")],
        [text("LinkedIn")],
      ),
    ]
    None, None -> []
  }

  html.footer([class("site-footer")], [
    html.div([class("footer-container")], [
      html.p([], [text("© " <> config.author)]),
      case social_links {
        [] -> text("")
        links -> html.div([class("social-links")], links)
      },
      case config.rss.enabled {
        True -> html.a([href("/feed.xml"), class("rss-link")], [text("RSS")])
        False -> text("")
      },
    ]),
  ])
}

/// Post card for listings
pub fn post_card(post: Post) -> Element(msg) {
  html.article([class("post-card")], [
    html.header([], [
      html.h2([class("post-title")], [
        html.a([href(post_url(post))], [text(post.title)]),
      ]),
      html.time([class("post-date"), attribute.attribute("datetime", post.date)], [
        text(post.date),
      ]),
    ]),
    case post.description {
      Some(desc) -> html.p([class("post-excerpt")], [text(desc)])
      None -> text("")
    },
    case post.categories {
      [] -> text("")
      cats ->
        html.div(
          [class("post-categories")],
          list.map(cats, fn(cat) {
            html.a([href(category_url(cat)), class("category-tag")], [text(cat)])
          }),
        )
    },
  ])
}

/// Category link with count
pub fn category_link(category: String, count: Int) -> Element(msg) {
  html.li([class("category-item")], [
    html.a([href(category_url(category)), class("category-link")], [
      html.span([class("category-name")], [text(category)]),
      html.span([class("category-count")], [text(" (" <> int.to_string(count) <> ")")]),
    ]),
  ])
}

/// Pagination controls
pub fn pagination(current_page: Int, total_pages: Int) -> Element(msg) {
  case total_pages <= 1 {
    True -> text("")
    False -> {
      let prev_link = case current_page > 1 {
        True -> {
          let prev_url = case current_page {
            2 -> "/posts/"
            n -> "/posts/page/" <> int.to_string(n - 1) <> "/"
          }
          html.a([href(prev_url), class("pagination-link prev")], [text("← Previous")])
        }
        False -> html.span([class("pagination-link prev disabled")], [text("← Previous")])
      }

      let next_link = case current_page < total_pages {
        True -> {
          let next_url =
            "/posts/page/" <> int.to_string(current_page + 1) <> "/"
          html.a([href(next_url), class("pagination-link next")], [text("Next →")])
        }
        False -> html.span([class("pagination-link next disabled")], [text("Next →")])
      }

      let page_info =
        "Page " <> int.to_string(current_page) <> " of " <> int.to_string(total_pages)

      html.nav([class("pagination")], [
        prev_link,
        html.span([class("pagination-info")], [text(page_info)]),
        next_link,
      ])
    }
  }
}

/// Section header
pub fn section_header(title: String) -> Element(msg) {
  html.h3([class("section-header")], [text(title)])
}
