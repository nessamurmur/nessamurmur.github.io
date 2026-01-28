# njssg

A static site generator built with Gleam, inspired by Hugo. Generate fast, type-safe blogs with Markdown content, TOML frontmatter, and Tailwind CSS styling.

## Features

- Markdown content with TOML frontmatter
- Posts with dates and categories
- Static pages (about, etc.)
- Category aggregation pages
- Pagination for post listings
- RSS feed generation
- Development server with live reload
- Tailwind CSS for styling
- Type-safe templates via Lustre

## Quick Start

### Prerequisites

- [Gleam](https://gleam.run/getting-started/installing/) (v1.0+)
- [Erlang/OTP](https://www.erlang.org/downloads) (v26+)
- [Node.js](https://nodejs.org/) (for Tailwind CSS)

### Setup

1. Install dependencies:

```sh
gleam deps download
npm install
```

2. Build the CSS:

```sh
npm run build:css
```

3. Build the site:

```sh
gleam run -- build
```

4. Or start the development server:

```sh
gleam run -- serve
```

The site will be available at http://localhost:8080

## CLI Commands

```sh
# Build the site to public/
gleam run -- build

# Start dev server with live reload (port 8080)
gleam run -- serve

# Create a new blog post
gleam run -- new post my-post-slug

# Create a new static page
gleam run -- new page my-page-slug
```

## Configuration

Edit `config.toml` to customize your site:

```toml
title = "My Blog"
description = "A personal blog powered by njssg"
author = "Your Name"
base_url = "https://yourdomain.com"
posts_per_page = 10

[nav]
links = [
  { title = "Posts", url = "/posts/" },
  { title = "Categories", url = "/categories/" },
  { title = "About", url = "/about/" },
]

[social]
github = "yourusername"
linkedin = "yourprofile"

[rss]
enabled = true
```

## Writing Content

### Blog Posts

Create Markdown files in `content/posts/` with TOML frontmatter:

```markdown
+++
title = "My First Post"
date = "2025-01-27"
categories = ["gleam", "programming"]
description = "A brief description for previews and RSS"
draft = false
+++

Your post content here in **Markdown**.

## Subheadings work

- Lists too
- With multiple items

Code blocks with syntax highlighting:

```gleam
pub fn hello(name: String) -> String {
  "Hello, " <> name <> "!"
}
```
```

The filename becomes the URL slug: `content/posts/my-first-post.md` becomes `/posts/my-first-post/`.

### Static Pages

Create pages in `content/pages/`:

```markdown
+++
title = "About"
description = "About this blog"
+++

This is a static page that appears at /about/.
```

### Draft Posts

Set `draft = true` in frontmatter to exclude a post from the build. Draft posts won't appear in listings, category pages, or RSS feeds.

## Generated Output

After running `gleam run -- build`, the `public/` directory contains:

```
public/
  index.html              # Home page with recent posts
  feed.xml                # RSS feed
  posts/
    index.html            # Posts listing (page 1)
    page/2/index.html     # Posts listing (page 2, etc.)
    my-first-post/
      index.html          # Individual post
  categories/
    index.html            # All categories listing
    gleam/
      index.html          # Posts in "gleam" category
    programming/
      index.html          # Posts in "programming" category
  about/
    index.html            # Static about page
  css/
    style.css             # Compiled Tailwind CSS
```

## Customizing Styles

The site uses Tailwind CSS. Edit `static/css/input.css` to customize styles, then rebuild:

```sh
npm run build:css
```

For development with auto-rebuilding CSS:

```sh
npm run watch:css
```

## Deployment

The `public/` directory contains static files ready for deployment to any static hosting:

- **GitHub Pages**: Push `public/` to a `gh-pages` branch
- **Netlify/Vercel**: Point build output to `public/`
- **S3/CloudFront**: Upload `public/` contents to your bucket

Example GitHub Actions workflow:

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: erlef/setup-beam@v1
        with:
          gleam-version: "1.0"
          otp-version: "26"

      - uses: actions/setup-node@v4
        with:
          node-version: "20"

      - run: gleam deps download
      - run: npm install
      - run: npm run build:css
      - run: gleam run -- build

      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

---

## Architecture

### Module Relationships

```
┌─────────────────────────────────────────────────────────────────┐
│                    nessamurmur_github_io.gleam                  │
│                         (CLI Entry Point)                       │
│                    build | serve | new post/page                │
└─────────────────────────┬───────────────────────────────────────┘
                          │
          ┌───────────────┼───────────────┐
          ▼               ▼               ▼
    ┌──────────┐    ┌──────────┐    ┌──────────┐
    │ builder  │    │  server  │    │ watcher  │
    │          │    │  (mist)  │    │ (polly)  │
    └────┬─────┘    └──────────┘    └──────────┘
         │
    ┌────┴────┬─────────┬─────────┐
    ▼         ▼         ▼         ▼
┌────────┐ ┌─────┐ ┌──────────┐ ┌───────────────┐
│markdown│ │ rss │ │ content  │ │   templates/  │
│ (mork) │ │     │ │          │ │ layout, home, │
└────┬───┘ └──┬──┘ └────┬─────┘ │ post, posts,  │
     │        │         │       │ page, cats... │
     │        │         │       └───────┬───────┘
     └────────┴────┬────┴───────────────┘
                   ▼
            ┌─────────────┐
            │frontmatter  │
            │   (tom)     │
            └──────┬──────┘
                   ▼
            ┌─────────────┐
            │   config    │
            │   (tom)     │
            └─────────────┘
```

### Data Flow

```
content/posts/*.md ──┐
                     │    ┌───────────────┐
content/pages/*.md ──┼───►│ frontmatter   │──► Post/Page types
                     │    │ parse()       │
config.toml ─────────┘    └───────────────┘
                                 │
                                 ▼
                          ┌───────────────┐
                          │   markdown    │──► Lustre Elements
                          │ render_to_    │
                          │ lustre()      │
                          └───────────────┘
                                 │
                                 ▼
                          ┌───────────────┐
                          │  templates/*  │──► Full HTML pages
                          │ render()      │
                          └───────────────┘
                                 │
                                 ▼
                          ┌───────────────┐
                          │   builder     │──► public/*.html
                          │ build_all()   │    public/feed.xml
                          └───────────────┘
```

### Key Design Decisions

1. **Lustre for HTML**: Using Lustre's SSR capabilities provides type-safe HTML generation with Gleam's compiler catching template errors at compile time.

2. **TOML frontmatter**: The `+++` delimiter style (Hugo-compatible) cleanly separates metadata from content.

3. **Result types everywhere**: All parsing operations return `Result` types, making error handling explicit and composable via pipelines.

4. **Builder pattern for output**: `BuildOutput` collects all generated files as a map, enabling easy testing without filesystem side effects.

5. **Pagination via records**: `Paginated` type holds pages with metadata (page number, total, has_next/prev) for template rendering.

### Gleam Patterns Used

- **Pipeline operator `|>`**: Readable data transformations throughout
- **Pattern matching**: Destructuring in function arguments and case expressions
- **Result chaining**: `result.try` and `result.map` for error propagation
- **Type aliases**: Clear domain modeling with Post, Page, Config types
- **Guard clauses**: Early returns via `use <- bool.guard`

### Extension Points

- **New content types**: Add to `content.gleam` and create corresponding template
- **New templates**: Add to `templates/` and wire into `builder.gleam`
- **Additional CLI commands**: Add new commands in main module using glint
- **Custom markdown extensions**: Modify `markdown.gleam` to add preprocessing

## Development

```sh
# Run tests
gleam test

# Build the project
gleam build

# Format code
gleam format
```

### Test Coverage

72 tests covering:
- Config parsing (valid/invalid TOML, defaults)
- Frontmatter extraction (various formats, edge cases)
- Content operations (sorting, filtering, pagination)
- Markdown rendering (HTML output, Lustre elements)
- RSS generation (valid XML, escaping)
- Template rendering (all page types)
- Builder orchestration (full site output)

## Dependencies

- [lustre](https://hexdocs.pm/lustre/) - HTML generation / SSR
- [mork](https://hexdocs.pm/mork/) + [mork_to_lustre](https://hexdocs.pm/mork_to_lustre/) - Markdown parsing
- [simplifile](https://hexdocs.pm/simplifile/) - File system operations
- [tom](https://hexdocs.pm/tom/) - TOML config parsing
- [glint](https://hexdocs.pm/glint/) - CLI argument parsing
- [wisp](https://hexdocs.pm/wisp/) + [mist](https://hexdocs.pm/mist/) - HTTP dev server
- [polly](https://hexdocs.pm/polly/) - File watching for live reload

## License

MIT
