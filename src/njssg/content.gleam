import gleam/list
import gleam/option.{type Option}
import gleam/set
import gleam/string

/// A blog post
pub type Post {
  Post(
    slug: String,
    title: String,
    date: String,
    categories: List(String),
    description: Option(String),
    draft: Bool,
    body: String,
  )
}

/// A static page
pub type Page {
  Page(slug: String, title: String, description: Option(String), body: String)
}

/// Paginated collection of posts
pub opaque type Paginated {
  Paginated(pages: List(List(Post)), per_page: Int)
}

/// Sort posts by date, newest first
pub fn sort_posts_by_date(posts: List(Post)) -> List(Post) {
  list.sort(posts, fn(a, b) {
    // Compare dates as strings (ISO format sorts correctly)
    string.compare(b.date, a.date)
  })
}

/// Filter out draft posts
pub fn filter_published(posts: List(Post)) -> List(Post) {
  list.filter(posts, fn(post) { !post.draft })
}

/// Get all unique categories from posts, sorted alphabetically
pub fn get_all_categories(posts: List(Post)) -> List(String) {
  posts
  |> list.flat_map(fn(post) { post.categories })
  |> set.from_list
  |> set.to_list
  |> list.sort(string.compare)
}

/// Filter posts by category
pub fn filter_by_category(posts: List(Post), category: String) -> List(Post) {
  list.filter(posts, fn(post) { list.contains(post.categories, category) })
}

/// Paginate posts into chunks
pub fn paginate(posts: List(Post), per_page: Int) -> Paginated {
  let pages = list.sized_chunk(posts, per_page)
  Paginated(pages: pages, per_page: per_page)
}

/// Get the total number of pages
pub fn page_count(paginated: Paginated) -> Int {
  list.length(paginated.pages)
}

/// Get posts for a specific page (1-indexed)
pub fn get_page(paginated: Paginated, page_num: Int) -> Result(List(Post), Nil) {
  case page_num < 1 {
    True -> Error(Nil)
    False -> {
      paginated.pages
      |> list.drop(page_num - 1)
      |> list.first
    }
  }
}

/// Count items in a list
pub fn count(items: List(a)) -> Int {
  list.length(items)
}

/// Generate URL for a post
pub fn post_url(post: Post) -> String {
  "/posts/" <> post.slug <> "/"
}

/// Generate URL for a page
pub fn page_url(page: Page) -> String {
  "/" <> page.slug <> "/"
}

/// Generate URL for a category
pub fn category_url(category: String) -> String {
  "/categories/" <> category <> "/"
}

/// Count posts per category
pub fn count_posts_per_category(posts: List(Post)) -> List(#(String, Int)) {
  let categories = get_all_categories(posts)
  list.map(categories, fn(cat) {
    let count = list.length(filter_by_category(posts, cat))
    #(cat, count)
  })
}
