import gleam/option.{None, Some}
import gleam/string
import gleeunit/should
import lustre/element
import njssg/config.{type Config, AuthorConfig, Config, NavConfig, NavLink, RssConfig, SocialLinks}
import njssg/content.{type Page, type Post, Page, Post}
import njssg/templates/components
import njssg/templates/layout
import njssg/templates/home
import njssg/templates/post as post_template
import njssg/templates/posts as posts_template
import njssg/templates/page as page_template
import njssg/templates/categories as categories_template
import njssg/templates/category as category_template

fn test_config() -> Config {
  Config(
    title: "Test Blog",
    description: "A test blog",
    author: "Test Author",
    base_url: "https://test.com",
    posts_per_page: 10,
    nav: NavConfig(links: [
      NavLink(title: "Posts", url: "/posts/"),
      NavLink(title: "About", url: "/about/"),
    ]),
    social: SocialLinks(github: Some("testuser"), linkedin: Some("testlinkedin"), mastodon: None, bluesky: None),
    rss: RssConfig(enabled: True),
    author_config: AuthorConfig(avatar_url: None, tagline: None, extra_links: []),
  )
}

fn test_post() -> Post {
  Post(
    slug: "test-post",
    title: "Test Post Title",
    date: "2025-01-27",
    categories: ["code", "gleam"],
    description: Some("Test description"),
    draft: False,
    body: "<p>Test content</p>",
  )
}

fn test_page() -> Page {
  Page(
    slug: "about",
    title: "About Me",
    description: Some("Learn about me"),
    body: "<p>About content</p>",
  )
}

// Component tests
pub fn nav_renders_links_test() {
  let config = test_config()
  let html = components.site_nav(config) |> element.to_string

  should.be_true(html |> string.contains("Posts"))
  should.be_true(html |> string.contains("/posts/"))
  should.be_true(html |> string.contains("About"))
  should.be_true(html |> string.contains("/about/"))
}

pub fn footer_renders_test() {
  let config = test_config()
  let html = components.site_footer(config) |> element.to_string

  should.be_true(html |> string.contains("<footer"))
}

pub fn post_card_renders_test() {
  let post = test_post()
  let html = components.post_card(post) |> element.to_string

  should.be_true(html |> string.contains("Test Post Title"))
  should.be_true(html |> string.contains("2025-01-27"))
  should.be_true(html |> string.contains("/posts/test-post/"))
}

// Layout tests
pub fn layout_includes_doctype_test() {
  let config = test_config()
  let html =
    layout.render(config, "Test Page", element.text("Content"))
    |> layout.to_html_string

  should.be_true(html |> string.starts_with("<!DOCTYPE html>"))
}

pub fn layout_includes_meta_tags_test() {
  let config = test_config()
  let html =
    layout.render(config, "Test Page", element.text("Content"))
    |> layout.to_html_string

  should.be_true(html |> string.contains("<meta charset=\"utf-8\""))
  should.be_true(html |> string.contains("viewport"))
}

pub fn layout_includes_title_test() {
  let config = test_config()
  let html =
    layout.render(config, "My Page", element.text("Content"))
    |> layout.to_html_string

  should.be_true(html |> string.contains("<title>My Page | Test Blog</title>"))
}

// Home template tests
pub fn home_renders_author_bio_test() {
  let config = test_config()
  let html = home.render(config) |> element.to_string

  should.be_true(html |> string.contains("home-page"))
}

// Post template tests
pub fn post_template_renders_content_test() {
  let config = test_config()
  let post = test_post()
  let html = post_template.render(config, post) |> element.to_string

  should.be_true(html |> string.contains("Test Post Title"))
  should.be_true(html |> string.contains("<p>Test content</p>"))
  should.be_true(html |> string.contains("2025-01-27"))
}

pub fn post_template_renders_categories_test() {
  let config = test_config()
  let post = test_post()
  let html = post_template.render(config, post) |> element.to_string

  should.be_true(html |> string.contains("code"))
  should.be_true(html |> string.contains("gleam"))
}

// Posts listing template tests
pub fn posts_listing_renders_test() {
  let config = test_config()
  let posts = [test_post()]
  let html = posts_template.render(config, posts, 1, 1) |> element.to_string

  should.be_true(html |> string.contains("Test Post Title"))
}

pub fn posts_pagination_test() {
  let config = test_config()
  let posts = [test_post()]
  // Page 1 of 3
  let html = posts_template.render(config, posts, 1, 3) |> element.to_string

  // Should have pagination links
  should.be_true(html |> string.contains("page"))
}

// Page template tests
pub fn page_template_renders_test() {
  let config = test_config()
  let page = test_page()
  let html = page_template.render(config, page) |> element.to_string

  should.be_true(html |> string.contains("About Me"))
  should.be_true(html |> string.contains("<p>About content</p>"))
}

// Categories template tests
pub fn categories_listing_test() {
  let config = test_config()
  let categories = [#("code", 5), #("gleam", 3), #("tutorial", 2)]
  let html = categories_template.render(config, categories) |> element.to_string

  should.be_true(html |> string.contains("code"))
  should.be_true(html |> string.contains("gleam"))
  should.be_true(html |> string.contains("tutorial"))
}

// Category template tests
pub fn category_posts_test() {
  let config = test_config()
  let posts = [test_post()]
  let html = category_template.render(config, "code", posts) |> element.to_string

  should.be_true(html |> string.contains("code"))
  should.be_true(html |> string.contains("Test Post Title"))
}
