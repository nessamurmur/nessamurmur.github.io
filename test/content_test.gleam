import gleam/option.{None, Some}
import gleeunit/should
import njssg/content.{Page, Post}

pub fn create_post_test() {
  let post =
    Post(
      slug: "my-first-post",
      title: "My First Post",
      date: "2025-01-27",
      categories: ["code", "gleam"],
      description: Some("A brief intro"),
      draft: False,
      body: "Post content here",
    )

  should.equal(post.slug, "my-first-post")
  should.equal(post.title, "My First Post")
  should.equal(post.date, "2025-01-27")
  should.equal(post.categories, ["code", "gleam"])
}

pub fn create_page_test() {
  let page =
    Page(
      slug: "about",
      title: "About Me",
      description: Some("Learn more about me"),
      body: "About page content",
    )

  should.equal(page.slug, "about")
  should.equal(page.title, "About Me")
}

pub fn sort_posts_by_date_test() {
  let posts = [
    Post(
      slug: "old",
      title: "Old Post",
      date: "2024-01-01",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "newest",
      title: "Newest Post",
      date: "2025-02-01",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "middle",
      title: "Middle Post",
      date: "2025-01-15",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
  ]

  let sorted = content.sort_posts_by_date(posts)

  // Should be newest first
  let assert [first, second, third] = sorted
  should.equal(first.slug, "newest")
  should.equal(second.slug, "middle")
  should.equal(third.slug, "old")
}

pub fn filter_drafts_test() {
  let posts = [
    Post(
      slug: "published",
      title: "Published",
      date: "2025-01-01",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "draft",
      title: "Draft",
      date: "2025-01-02",
      categories: [],
      description: None,
      draft: True,
      body: "",
    ),
    Post(
      slug: "also-published",
      title: "Also Published",
      date: "2025-01-03",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
  ]

  let published = content.filter_published(posts)

  should.equal(content.count(published), 2)
  let assert [first, second] = published
  should.equal(first.slug, "published")
  should.equal(second.slug, "also-published")
}

pub fn get_all_categories_test() {
  let posts = [
    Post(
      slug: "post1",
      title: "Post 1",
      date: "2025-01-01",
      categories: ["code", "gleam"],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "post2",
      title: "Post 2",
      date: "2025-01-02",
      categories: ["gleam", "tutorial"],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "post3",
      title: "Post 3",
      date: "2025-01-03",
      categories: ["code"],
      description: None,
      draft: False,
      body: "",
    ),
  ]

  let categories = content.get_all_categories(posts)

  // Should be unique and sorted
  should.equal(categories, ["code", "gleam", "tutorial"])
}

pub fn filter_by_category_test() {
  let posts = [
    Post(
      slug: "post1",
      title: "Post 1",
      date: "2025-01-01",
      categories: ["code", "gleam"],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "post2",
      title: "Post 2",
      date: "2025-01-02",
      categories: ["tutorial"],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "post3",
      title: "Post 3",
      date: "2025-01-03",
      categories: ["code"],
      description: None,
      draft: False,
      body: "",
    ),
  ]

  let code_posts = content.filter_by_category(posts, "code")

  should.equal(content.count(code_posts), 2)
  let assert [first, second] = code_posts
  should.equal(first.slug, "post1")
  should.equal(second.slug, "post3")
}

pub fn paginate_posts_test() {
  let posts = [
    Post(
      slug: "p1",
      title: "P1",
      date: "2025-01-01",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "p2",
      title: "P2",
      date: "2025-01-02",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "p3",
      title: "P3",
      date: "2025-01-03",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "p4",
      title: "P4",
      date: "2025-01-04",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
    Post(
      slug: "p5",
      title: "P5",
      date: "2025-01-05",
      categories: [],
      description: None,
      draft: False,
      body: "",
    ),
  ]

  // 2 posts per page
  let pages = content.paginate(posts, 2)

  should.equal(content.page_count(pages), 3)

  let assert Ok(page1) = content.get_page(pages, 1)
  should.equal(content.count(page1), 2)

  let assert Ok(page2) = content.get_page(pages, 2)
  should.equal(content.count(page2), 2)

  let assert Ok(page3) = content.get_page(pages, 3)
  should.equal(content.count(page3), 1)
}

pub fn post_url_test() {
  let post =
    Post(
      slug: "my-post",
      title: "My Post",
      date: "2025-01-01",
      categories: [],
      description: None,
      draft: False,
      body: "",
    )

  should.equal(content.post_url(post), "/posts/my-post/")
}

pub fn page_url_test() {
  let page =
    Page(slug: "about", title: "About", description: None, body: "")

  should.equal(content.page_url(page), "/about/")
}

pub fn category_url_test() {
  should.equal(content.category_url("code"), "/categories/code/")
  should.equal(content.category_url("gleam"), "/categories/gleam/")
}
