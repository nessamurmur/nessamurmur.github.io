import argv
import filepath
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import glint
import njssg/builder
import njssg/config
import njssg/content.{type Page, type Post}
import njssg/markdown
import njssg/server
import simplifile

const default_port = 8080

const posts_dir = "content/posts"

const pages_dir = "content/pages"

const public_dir = "public"

const config_file = "config.toml"

pub fn main() {
  glint.new()
  |> glint.with_name("njssg")
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: [], do: build_command())
  |> glint.add(at: ["build"], do: build_command())
  |> glint.add(at: ["serve"], do: serve_command())
  |> glint.add(at: ["new", "post"], do: new_post_command())
  |> glint.add(at: ["new", "page"], do: new_page_command())
  |> glint.run(argv.load().arguments)
}

// Build command
fn build_command() -> glint.Command(Nil) {
  use <- glint.command_help("Build the static site to public/")
  use _named, _args, _flags <- glint.command()
  do_build()
}

fn do_build() -> Nil {
  io.println("Building site...")

  // Load config
  let config = case load_config() {
    Ok(c) -> c
    Error(e) -> {
      io.println("Error loading config: " <> e)
      panic as "Failed to load config"
    }
  }

  // Load content
  let posts = load_posts()
  let pages = load_pages()

  io.println(
    "Found "
    <> string.inspect(list.length(posts))
    <> " posts and "
    <> string.inspect(list.length(pages))
    <> " pages",
  )

  // Build all content
  let output = builder.build_all(config, posts, pages)

  // Write output files
  let paths = builder.get_all_paths(output)
  list.each(paths, fn(path) {
    let full_path = public_dir <> "/" <> path
    let dir = filepath.directory_name(full_path)

    // Create directory if needed
    let _ = simplifile.create_directory_all(dir)

    // Write file
    case builder.get_output(output, path) {
      Ok(content) -> {
        case simplifile.write(full_path, content) {
          Ok(_) -> io.println("  Created: " <> path)
          Error(_) -> io.println("  Error writing: " <> path)
        }
      }
      Error(_) -> Nil
    }
  })

  io.println("Build complete! Output in " <> public_dir <> "/")
}

// Serve command
fn serve_command() -> glint.Command(Nil) {
  use <- glint.command_help("Start development server with live reload")
  use _named, _args, _flags <- glint.command()
  do_serve()
}

fn do_serve() -> Nil {
  // First build
  do_build()

  // Then start server
  io.println("")
  case server.start(public_dir, default_port) {
    Ok(_) -> Nil
    Error(e) -> io.println("Error starting server: " <> e)
  }
}

// New post command
fn new_post_command() -> glint.Command(Nil) {
  use <- glint.command_help("Create a new blog post")
  use <- glint.unnamed_args(glint.MinArgs(1))
  use _named, args, _flags <- glint.command()
  case args {
    [slug, ..] -> create_new_post(slug)
    _ -> io.println("Usage: njssg new post <slug>")
  }
}

fn create_new_post(slug: String) -> Nil {
  let path = posts_dir <> "/" <> slug <> ".md"

  // Check if file exists
  case simplifile.is_file(path) {
    Ok(True) -> {
      io.println("Error: Post already exists at " <> path)
    }
    _ -> {
      // Create directory if needed
      let _ = simplifile.create_directory_all(posts_dir)

      // Get current date (placeholder)
      let date = "2025-01-27"

      let content =
        "+++
title = \""
        <> slug_to_title(slug)
        <> "\"
date = \""
        <> date
        <> "\"
categories = []
description = \"\"
draft = true
+++

Write your post content here...
"

      case simplifile.write(path, content) {
        Ok(_) -> io.println("Created new post: " <> path)
        Error(_) -> io.println("Error creating post at " <> path)
      }
    }
  }
}

// New page command
fn new_page_command() -> glint.Command(Nil) {
  use <- glint.command_help("Create a new static page")
  use <- glint.unnamed_args(glint.MinArgs(1))
  use _named, args, _flags <- glint.command()
  case args {
    [slug, ..] -> create_new_page(slug)
    _ -> io.println("Usage: njssg new page <slug>")
  }
}

fn create_new_page(slug: String) -> Nil {
  let path = pages_dir <> "/" <> slug <> ".md"

  // Check if file exists
  case simplifile.is_file(path) {
    Ok(True) -> {
      io.println("Error: Page already exists at " <> path)
    }
    _ -> {
      // Create directory if needed
      let _ = simplifile.create_directory_all(pages_dir)

      let content =
        "+++
title = \""
        <> slug_to_title(slug)
        <> "\"
description = \"\"
+++

Write your page content here...
"

      case simplifile.write(path, content) {
        Ok(_) -> io.println("Created new page: " <> path)
        Error(_) -> io.println("Error creating page at " <> path)
      }
    }
  }
}

// Helper functions

fn load_config() -> Result(config.Config, String) {
  case simplifile.read(config_file) {
    Ok(content) ->
      config.parse(content)
      |> result.map_error(fn(_) { "Failed to parse config.toml" })
    Error(_) -> Error("Could not read config.toml")
  }
}

fn load_posts() -> List(Post) {
  case simplifile.read_directory(posts_dir) {
    Ok(files) -> {
      files
      |> list.filter(fn(f) { string.ends_with(f, ".md") })
      |> list.filter_map(fn(file) {
        let path = posts_dir <> "/" <> file
        let slug = string.drop_end(file, 3)
        case simplifile.read(path) {
          Ok(content) ->
            markdown.load_post(slug, content)
            |> result.replace_error(Nil)
          Error(_) -> Error(Nil)
        }
      })
    }
    Error(_) -> []
  }
}

fn load_pages() -> List(Page) {
  case simplifile.read_directory(pages_dir) {
    Ok(files) -> {
      files
      |> list.filter(fn(f) { string.ends_with(f, ".md") })
      |> list.filter_map(fn(file) {
        let path = pages_dir <> "/" <> file
        let slug = string.drop_end(file, 3)
        case simplifile.read(path) {
          Ok(content) ->
            markdown.load_page(slug, content)
            |> result.replace_error(Nil)
          Error(_) -> Error(Nil)
        }
      })
    }
    Error(_) -> []
  }
}

fn slug_to_title(slug: String) -> String {
  slug
  |> string.replace("-", " ")
  |> string.capitalise
}
