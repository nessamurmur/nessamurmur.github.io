import gleam/option.{None, Some}
import gleam/string
import gleeunit/should
import njssg/config.{AuthorConfig, Config, NavConfig, RssConfig, SocialLinks}
import njssg/content.{Post}
import njssg/rss

pub fn generate_rss_basic_test() {
  let config =
    Config(
      title: "Test Blog",
      description: "A test blog",
      author: "Test Author",
      base_url: "https://test.com",
      posts_per_page: 10,
      nav: NavConfig(links: []),
      social: SocialLinks(github: None, linkedin: None),
      rss: RssConfig(enabled: True),
      author_config: AuthorConfig(avatar_url: None, tagline: None, extra_links: []),
    )

  let posts = [
    Post(
      slug: "first-post",
      title: "First Post",
      date: "2025-01-27",
      categories: ["test"],
      description: Some("First post description"),
      draft: False,
      body: "<p>First post content</p>",
    ),
  ]

  let xml = rss.generate(config, posts)

  // Check XML declaration
  should.be_true(xml |> string.starts_with("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"))

  // Check RSS structure
  should.be_true(xml |> string.contains("<rss version=\"2.0\""))
  should.be_true(xml |> string.contains("<channel>"))
  should.be_true(xml |> string.contains("</channel>"))
  should.be_true(xml |> string.contains("</rss>"))
}

pub fn generate_rss_channel_info_test() {
  let config =
    Config(
      title: "My Blog",
      description: "My personal blog",
      author: "Nessa",
      base_url: "https://blog.example.com",
      posts_per_page: 10,
      nav: NavConfig(links: []),
      social: SocialLinks(github: None, linkedin: None),
      rss: RssConfig(enabled: True),
      author_config: AuthorConfig(avatar_url: None, tagline: None, extra_links: []),
    )

  let xml = rss.generate(config, [])

  should.be_true(xml |> string.contains("<title>My Blog</title>"))
  should.be_true(xml |> string.contains("<description>My personal blog</description>"))
  should.be_true(xml |> string.contains("<link>https://blog.example.com</link>"))
}

pub fn generate_rss_items_test() {
  let config =
    Config(
      title: "Test",
      description: "Test",
      author: "Test",
      base_url: "https://test.com",
      posts_per_page: 10,
      nav: NavConfig(links: []),
      social: SocialLinks(github: None, linkedin: None),
      rss: RssConfig(enabled: True),
      author_config: AuthorConfig(avatar_url: None, tagline: None, extra_links: []),
    )

  let posts = [
    Post(
      slug: "my-post",
      title: "My Post Title",
      date: "2025-01-27",
      categories: ["code", "gleam"],
      description: Some("Post description"),
      draft: False,
      body: "<p>Content here</p>",
    ),
  ]

  let xml = rss.generate(config, posts)

  should.be_true(xml |> string.contains("<item>"))
  should.be_true(xml |> string.contains("<title>My Post Title</title>"))
  should.be_true(xml |> string.contains("<link>https://test.com/posts/my-post/</link>"))
  should.be_true(xml |> string.contains("<description>Post description</description>"))
  should.be_true(xml |> string.contains("<category>code</category>"))
  should.be_true(xml |> string.contains("<category>gleam</category>"))
}

pub fn generate_rss_escape_special_chars_test() {
  let config =
    Config(
      title: "Test & Blog <Special>",
      description: "Description with \"quotes\" & <tags>",
      author: "Test",
      base_url: "https://test.com",
      posts_per_page: 10,
      nav: NavConfig(links: []),
      social: SocialLinks(github: None, linkedin: None),
      rss: RssConfig(enabled: True),
      author_config: AuthorConfig(avatar_url: None, tagline: None, extra_links: []),
    )

  let posts = [
    Post(
      slug: "special",
      title: "Post & Title <here>",
      date: "2025-01-27",
      categories: [],
      description: Some("Description \"with\" special & chars"),
      draft: False,
      body: "",
    ),
  ]

  let xml = rss.generate(config, posts)

  // Special chars should be escaped
  should.be_true(xml |> string.contains("&amp;"))
  should.be_true(xml |> string.contains("&lt;"))
  should.be_true(xml |> string.contains("&gt;"))
}

pub fn generate_rss_multiple_posts_test() {
  let config =
    Config(
      title: "Test",
      description: "Test",
      author: "Test",
      base_url: "https://test.com",
      posts_per_page: 10,
      nav: NavConfig(links: []),
      social: SocialLinks(github: None, linkedin: None),
      rss: RssConfig(enabled: True),
      author_config: AuthorConfig(avatar_url: None, tagline: None, extra_links: []),
    )

  let posts = [
    Post(
      slug: "post-1",
      title: "Post 1",
      date: "2025-01-25",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "post-2",
      title: "Post 2",
      date: "2025-01-26",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "post-3",
      title: "Post 3",
      date: "2025-01-27",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
  ]

  let xml = rss.generate(config, posts)

  // Count item tags (should be 3)
  let item_count = count_occurrences(xml, "<item>")
  should.equal(item_count, 3)
}

pub fn generate_rss_no_description_test() {
  let config =
    Config(
      title: "Test",
      description: "Test",
      author: "Test",
      base_url: "https://test.com",
      posts_per_page: 10,
      nav: NavConfig(links: []),
      social: SocialLinks(github: None, linkedin: None),
      rss: RssConfig(enabled: True),
      author_config: AuthorConfig(avatar_url: None, tagline: None, extra_links: []),
    )

  let posts = [
    Post(
      slug: "no-desc",
      title: "No Description Post",
      date: "2025-01-27",
      categories: [],
      description: None,
      draft: False,
      body: "<p>The body content</p>",
    ),
  ]

  let xml = rss.generate(config, posts)

  // Should still have item with description from body (truncated)
  should.be_true(xml |> string.contains("<item>"))
  should.be_true(xml |> string.contains("No Description Post"))
}

fn count_occurrences(haystack: String, needle: String) -> Int {
  do_count_occurrences(haystack, needle, 0)
}

fn do_count_occurrences(haystack: String, needle: String, count: Int) -> Int {
  case string.split_once(haystack, needle) {
    Ok(#(_before, after)) -> do_count_occurrences(after, needle, count + 1)
    Error(_) -> count
  }
}
