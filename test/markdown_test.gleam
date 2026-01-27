import gleeunit/should
import lustre/element
import njssg/markdown

pub fn render_simple_markdown_test() {
  let md = "Hello **world**!"
  let html = markdown.render_to_string(md)

  should.be_true(html |> contains("<strong>world</strong>"))
}

pub fn render_heading_test() {
  let md = "# Hello World"
  let html = markdown.render_to_string(md)

  should.be_true(html |> contains("<h1>"))
  should.be_true(html |> contains("Hello World"))
}

pub fn render_code_block_test() {
  let md =
    "```gleam
pub fn main() {
  io.println(\"Hello\")
}
```"
  let html = markdown.render_to_string(md)

  should.be_true(html |> contains("<pre>"))
  should.be_true(html |> contains("<code"))
}

pub fn render_link_test() {
  let md = "Check out [Gleam](https://gleam.run)!"
  let html = markdown.render_to_string(md)

  should.be_true(html |> contains("<a"))
  should.be_true(html |> contains("href=\"https://gleam.run\""))
}

pub fn render_list_test() {
  let md =
    "- Item 1
- Item 2
- Item 3"
  let html = markdown.render_to_string(md)

  should.be_true(html |> contains("<ul>"))
  should.be_true(html |> contains("<li>"))
}

pub fn render_paragraph_test() {
  let md =
    "First paragraph.

Second paragraph."
  let html = markdown.render_to_string(md)

  should.be_true(html |> contains("<p>"))
}

pub fn to_lustre_element_test() {
  let md = "Hello **world**!"
  let el = markdown.render_to_lustre(md)

  // Should return a Lustre element
  let html = element.to_string(el)
  should.be_true(html |> contains("<strong>world</strong>"))
}

pub fn load_post_from_content_test() {
  // Test loading a post from markdown content
  let content =
    "+++
title = \"Test Post\"
date = \"2025-01-27\"
categories = [\"test\"]
+++

This is the **post content**."

  let result = markdown.load_post("test-post", content)
  should.be_ok(result)

  let assert Ok(post) = result
  should.equal(post.slug, "test-post")
  should.equal(post.title, "Test Post")
  should.equal(post.date, "2025-01-27")
  should.be_true(post.body |> contains("<strong>post content</strong>"))
}

pub fn load_page_from_content_test() {
  let content =
    "+++
title = \"About Me\"
description = \"Learn more\"
+++

This is the **about page**."

  let result = markdown.load_page("about", content)
  should.be_ok(result)

  let assert Ok(page) = result
  should.equal(page.slug, "about")
  should.equal(page.title, "About Me")
  should.be_true(page.body |> contains("<strong>about page</strong>"))
}

pub fn load_draft_post_test() {
  let content =
    "+++
title = \"Draft Post\"
date = \"2025-01-27\"
draft = true
+++

Draft content."

  let assert Ok(post) = markdown.load_post("draft-post", content)
  should.be_true(post.draft)
}

// Helper function
fn contains(haystack: String, needle: String) -> Bool {
  case haystack {
    _ if haystack == needle -> True
    _ -> {
      let len = string_length(haystack)
      let needle_len = string_length(needle)
      case len < needle_len {
        True -> False
        False -> search_contains(haystack, needle, 0, len - needle_len)
      }
    }
  }
}

fn search_contains(
  haystack: String,
  needle: String,
  index: Int,
  max_index: Int,
) -> Bool {
  case index > max_index {
    True -> False
    False -> {
      let slice = string_slice(haystack, index, string_length(needle))
      case slice == needle {
        True -> True
        False -> search_contains(haystack, needle, index + 1, max_index)
      }
    }
  }
}

@external(erlang, "string", "length")
fn string_length(s: String) -> Int

@external(erlang, "string", "slice")
fn string_slice(s: String, start: Int, length: Int) -> String
