import gleam/option.{None, Some}
import gleam/string
import gleeunit/should
import njssg/builder
import njssg/config.{type Config, AuthorConfig, Config, NavConfig, RssConfig, SocialLinks}
import njssg/content.{type Page, type Post, Page, Post}

fn test_config() -> Config {
  Config(
    title: "Test Blog",
    description: "A test blog",
    author: "Test Author",
    base_url: "https://test.com",
    posts_per_page: 2,
    nav: NavConfig(links: []),
    social: SocialLinks(github: None, linkedin: None, mastodon: None, bluesky: None),
    rss: RssConfig(enabled: True),
    author_config: AuthorConfig(avatar_url: None, tagline: None, extra_links: []),
  )
}

fn test_post(slug: String, date: String) -> Post {
  Post(
    slug: slug,
    title: "Test Post: " <> slug,
    date: date,
    categories: ["test"],
    description: Some("Description for " <> slug),
    draft: False,
    body: "<p>Content for " <> slug <> "</p>",
  )
}

fn test_page() -> Page {
  Page(
    slug: "about",
    title: "About",
    description: Some("About page"),
    body: "<p>About content</p>",
  )
}

// Test build output generation
pub fn build_home_page_test() {
  let config = test_config()
  let posts = [test_post("post-1", "2025-01-27")]
  let pages = []

  let output = builder.build_all(config, posts, pages)

  // Should have index.html
  let assert Ok(home) = builder.get_output(output, "index.html")
  should.be_true(home |> string.contains("<!DOCTYPE html>"))
  should.be_true(home |> string.contains("Test Blog"))
}

pub fn build_post_pages_test() {
  let config = test_config()
  let posts = [test_post("my-post", "2025-01-27")]
  let pages = []

  let output = builder.build_all(config, posts, pages)

  // Should have posts/my-post/index.html
  let assert Ok(post_html) =
    builder.get_output(output, "posts/my-post/index.html")
  should.be_true(post_html |> string.contains("Test Post: my-post"))
}

pub fn build_posts_listing_test() {
  let config = test_config()
  let posts = [
    test_post("post-1", "2025-01-27"),
    test_post("post-2", "2025-01-26"),
  ]
  let pages = []

  let output = builder.build_all(config, posts, pages)

  // Should have posts/index.html
  let assert Ok(listing) = builder.get_output(output, "posts/index.html")
  should.be_true(listing |> string.contains("post-1"))
}

pub fn build_pagination_test() {
  let config = test_config()  // posts_per_page = 2
  let posts = [
    test_post("post-1", "2025-01-27"),
    test_post("post-2", "2025-01-26"),
    test_post("post-3", "2025-01-25"),
  ]
  let pages = []

  let output = builder.build_all(config, posts, pages)

  // Should have page 2
  let assert Ok(page2) = builder.get_output(output, "posts/page/2/index.html")
  should.be_true(page2 |> string.contains("post-3"))
}

pub fn build_static_page_test() {
  let config = test_config()
  let posts = []
  let pages = [test_page()]

  let output = builder.build_all(config, posts, pages)

  // Should have about/index.html
  let assert Ok(about) = builder.get_output(output, "about/index.html")
  should.be_true(about |> string.contains("About"))
}

pub fn build_categories_listing_test() {
  let config = test_config()
  let posts = [
    Post(
      slug: "post-1",
      title: "Post 1",
      date: "2025-01-27",
      categories: ["code", "gleam"],
      description: None,
      draft: False,
      body: "",
    ),
  ]
  let pages = []

  let output = builder.build_all(config, posts, pages)

  // Should have categories/index.html
  let assert Ok(cats) = builder.get_output(output, "categories/index.html")
  should.be_true(cats |> string.contains("code"))
  should.be_true(cats |> string.contains("gleam"))
}

pub fn build_category_page_test() {
  let config = test_config()
  let posts = [
    Post(
      slug: "post-1",
      title: "Post 1",
      date: "2025-01-27",
      categories: ["code"],
      description: None,
      draft: False,
      body: "",
    ),
  ]
  let pages = []

  let output = builder.build_all(config, posts, pages)

  // Should have categories/code/index.html
  let assert Ok(cat_page) =
    builder.get_output(output, "categories/code/index.html")
  should.be_true(cat_page |> string.contains("code"))
}

pub fn build_rss_feed_test() {
  let config = test_config()
  let posts = [test_post("post-1", "2025-01-27")]
  let pages = []

  let output = builder.build_all(config, posts, pages)

  // Should have feed.xml
  let assert Ok(feed) = builder.get_output(output, "feed.xml")
  should.be_true(feed |> string.contains("<?xml"))
  should.be_true(feed |> string.contains("<rss"))
}

pub fn build_excludes_drafts_test() {
  let config = test_config()
  let posts = [
    Post(
      slug: "published",
      title: "Published",
      date: "2025-01-27",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "draft",
      title: "Draft Post",
      date: "2025-01-26",
      categories: [],
      description: None,
      draft: True,
      body: "",
    ),
  ]
  let pages = []

  let output = builder.build_all(config, posts, pages)

  // Should NOT have draft post
  let result = builder.get_output(output, "posts/draft/index.html")
  should.be_error(result)
}

pub fn get_output_paths_test() {
  let config = test_config()
  let posts = [test_post("post-1", "2025-01-27")]
  let pages = [test_page()]

  let output = builder.build_all(config, posts, pages)
  let paths = builder.get_all_paths(output)

  should.be_true(paths |> contains("index.html"))
  should.be_true(paths |> contains("posts/index.html"))
  should.be_true(paths |> contains("posts/post-1/index.html"))
  should.be_true(paths |> contains("about/index.html"))
  should.be_true(paths |> contains("feed.xml"))
}

fn contains(list: List(String), item: String) -> Bool {
  case list {
    [] -> False
    [head, ..tail] ->
      case head == item {
        True -> True
        False -> contains(tail, item)
      }
  }
}
