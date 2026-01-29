import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import njssg/config.{type Config}
import njssg/content.{
  type Page, type Post, count_posts_per_category, filter_by_category,
  filter_published, get_all_categories, get_page, page_count, paginate,
  sort_posts_by_date,
}
import njssg/rss
import njssg/templates/categories as categories_template
import njssg/templates/category as category_template
import njssg/templates/home as home_template
import njssg/templates/layout
import njssg/templates/page as page_template
import njssg/templates/post as post_template
import njssg/templates/posts as posts_template

/// Build output - a map of path -> content
pub opaque type BuildOutput {
  BuildOutput(files: Dict(String, String))
}

/// Build all site content
pub fn build_all(
  config: Config,
  posts: List(Post),
  pages: List(Page),
) -> BuildOutput {
  // Filter out drafts and sort by date
  let published_posts =
    posts
    |> filter_published
    |> sort_posts_by_date

  let files =
    dict.new()
    |> build_home(config, published_posts)
    |> build_posts_listing(config, published_posts)
    |> build_individual_posts(config, published_posts)
    |> build_pages(config, pages)
    |> build_categories(config, published_posts)
    |> build_rss(config, published_posts)

  BuildOutput(files: files)
}

/// Get output content by path
pub fn get_output(output: BuildOutput, path: String) -> Result(String, Nil) {
  dict.get(output.files, path)
}

/// Get all output paths
pub fn get_all_paths(output: BuildOutput) -> List(String) {
  dict.keys(output.files)
}

// Build home page
fn build_home(
  files: Dict(String, String),
  config: Config,
  _posts: List(Post),
) -> Dict(String, String) {
  let content = home_template.render(config)
  let html =
    layout.render(config, "Home", content)
    |> layout.to_html_string

  dict.insert(files, "index.html", html)
}

// Build posts listing with pagination
fn build_posts_listing(
  files: Dict(String, String),
  config: Config,
  posts: List(Post),
) -> Dict(String, String) {
  let paginated = paginate(posts, config.posts_per_page)
  let total_pages = page_count(paginated)

  list.range(1, total_pages)
  |> list.fold(files, fn(acc, page_num) {
    let page_posts = get_page(paginated, page_num) |> result.unwrap([])
    let content = posts_template.render(config, page_posts, page_num, total_pages)
    let html =
      layout.render(config, "Posts", content)
      |> layout.to_html_string

    let path = case page_num {
      1 -> "posts/index.html"
      n -> "posts/page/" <> int.to_string(n) <> "/index.html"
    }

    dict.insert(acc, path, html)
  })
}

// Build individual post pages
fn build_individual_posts(
  files: Dict(String, String),
  config: Config,
  posts: List(Post),
) -> Dict(String, String) {
  list.fold(posts, files, fn(acc, post) {
    let content = post_template.render(config, post)
    let html =
      layout.render(config, post.title, content)
      |> layout.to_html_string

    let path = "posts/" <> post.slug <> "/index.html"
    dict.insert(acc, path, html)
  })
}

// Build static pages
fn build_pages(
  files: Dict(String, String),
  config: Config,
  pages: List(Page),
) -> Dict(String, String) {
  list.fold(pages, files, fn(acc, page) {
    let content = page_template.render(config, page)
    let html =
      layout.render(config, page.title, content)
      |> layout.to_html_string

    let path = page.slug <> "/index.html"
    dict.insert(acc, path, html)
  })
}

// Build category pages
fn build_categories(
  files: Dict(String, String),
  config: Config,
  posts: List(Post),
) -> Dict(String, String) {
  let categories = get_all_categories(posts)
  let category_counts = count_posts_per_category(posts)

  // Build categories listing
  let listing_content = categories_template.render(config, category_counts)
  let listing_html =
    layout.render(config, "Categories", listing_content)
    |> layout.to_html_string

  let files_with_listing =
    dict.insert(files, "categories/index.html", listing_html)

  // Build individual category pages
  list.fold(categories, files_with_listing, fn(acc, category) {
    let cat_posts = filter_by_category(posts, category)
    let content = category_template.render(config, category, cat_posts)
    let html =
      layout.render(config, "Category: " <> category, content)
      |> layout.to_html_string

    let path = "categories/" <> category <> "/index.html"
    dict.insert(acc, path, html)
  })
}

// Build RSS feed
fn build_rss(
  files: Dict(String, String),
  config: Config,
  posts: List(Post),
) -> Dict(String, String) {
  case config.rss.enabled {
    False -> files
    True -> {
      let xml = rss.generate(config, posts)
      dict.insert(files, "feed.xml", xml)
    }
  }
}
