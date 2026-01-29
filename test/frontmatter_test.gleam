import gleam/option.{None, Some}
import gleeunit/should
import njssg/frontmatter

pub fn parse_valid_frontmatter_test() {
  let content =
    "+++
title = \"My First Post\"
date = \"2025-01-27\"
categories = [\"code\", \"gleam\"]
description = \"A brief intro to this post\"
draft = false
+++

Post content in markdown..."

  let result = frontmatter.parse(content)
  should.be_ok(result)

  let assert Ok(#(fm, body)) = result
  should.equal(fm.title, "My First Post")
  should.equal(fm.date, "2025-01-27")
  should.equal(fm.categories, ["code", "gleam"])
  should.equal(fm.description, Some("A brief intro to this post"))
  should.equal(fm.draft, False)
  should.equal(body, "\n\nPost content in markdown...")
}

pub fn parse_minimal_frontmatter_test() {
  let content =
    "+++
title = \"Minimal Post\"
date = \"2025-01-01\"
+++

Content here"

  let assert Ok(#(fm, body)) = frontmatter.parse(content)
  should.equal(fm.title, "Minimal Post")
  should.equal(fm.date, "2025-01-01")
  should.equal(fm.categories, [])
  should.equal(fm.description, None)
  should.equal(fm.draft, False)
  should.equal(body, "\n\nContent here")
}

pub fn parse_draft_post_test() {
  let content =
    "+++
title = \"Draft Post\"
date = \"2025-01-15\"
draft = true
+++

WIP content"

  let assert Ok(#(fm, _body)) = frontmatter.parse(content)
  should.equal(fm.draft, True)
}

pub fn parse_missing_title_test() {
  let content =
    "+++
date = \"2025-01-27\"
+++

Content without title"

  let result = frontmatter.parse(content)
  should.be_error(result)
}

pub fn parse_missing_date_test() {
  let content =
    "+++
title = \"No Date Post\"
+++

Content without date"

  let result = frontmatter.parse(content)
  should.be_error(result)
}

pub fn parse_missing_delimiters_test() {
  let content =
    "title = \"No Delimiters\"
date = \"2025-01-27\"

This has no frontmatter delimiters"

  let result = frontmatter.parse(content)
  should.be_error(result)
}

pub fn parse_missing_closing_delimiter_test() {
  let content =
    "+++
title = \"Unclosed\"
date = \"2025-01-27\"

Content without closing delimiter"

  let result = frontmatter.parse(content)
  should.be_error(result)
}

pub fn parse_empty_categories_test() {
  let content =
    "+++
title = \"Test\"
date = \"2025-01-01\"
categories = []
+++

Content"

  let assert Ok(#(fm, _body)) = frontmatter.parse(content)
  should.equal(fm.categories, [])
}

pub fn parse_single_category_test() {
  let content =
    "+++
title = \"Test\"
date = \"2025-01-01\"
categories = [\"single\"]
+++

Content"

  let assert Ok(#(fm, _body)) = frontmatter.parse(content)
  should.equal(fm.categories, ["single"])
}

pub fn parse_page_frontmatter_test() {
  // Pages have simpler frontmatter (no date required, no categories)
  let content =
    "+++
title = \"About Me\"
description = \"Learn more about me\"
+++

About page content"

  let result = frontmatter.parse_page(content)
  should.be_ok(result)

  let assert Ok(#(fm, body)) = result
  should.equal(fm.title, "About Me")
  should.equal(fm.description, Some("Learn more about me"))
  should.equal(body, "\n\nAbout page content")
}

pub fn parse_page_minimal_test() {
  let content =
    "+++
title = \"Contact\"
+++

Contact info"

  let assert Ok(#(fm, _body)) = frontmatter.parse_page(content)
  should.equal(fm.title, "Contact")
  should.equal(fm.description, None)
}
