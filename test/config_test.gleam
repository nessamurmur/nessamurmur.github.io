import gleam/option.{None, Some}
import gleeunit/should
import njssg/config.{NavLink}

pub fn parse_valid_config_test() {
  let toml = "
title = \"My Blog\"
description = \"A personal blog\"
author = \"Nessa Jane\"
base_url = \"https://blog.nessajane.tech\"
posts_per_page = 10

[nav]
links = [
  { title = \"Posts\", url = \"/posts/\" },
  { title = \"Categories\", url = \"/categories/\" },
  { title = \"About\", url = \"/about/\" },
]

[social]
github = \"nessamurmur\"
linkedin = \"nessajane\"

[rss]
enabled = true
"

  let result = config.parse(toml)

  should.be_ok(result)

  let assert Ok(cfg) = result
  should.equal(cfg.title, "My Blog")
  should.equal(cfg.description, "A personal blog")
  should.equal(cfg.author, "Nessa Jane")
  should.equal(cfg.base_url, "https://blog.nessajane.tech")
  should.equal(cfg.posts_per_page, 10)
}

pub fn parse_nav_links_test() {
  let toml = "
title = \"Test\"
description = \"Test\"
author = \"Test\"
base_url = \"https://test.com\"
posts_per_page = 5

[nav]
links = [
  { title = \"Home\", url = \"/\" },
  { title = \"About\", url = \"/about/\" },
]
"

  let assert Ok(cfg) = config.parse(toml)
  should.equal(config.get_nav_links(cfg), [
    NavLink(title: "Home", url: "/"),
    NavLink(title: "About", url: "/about/"),
  ])
}

pub fn parse_social_links_test() {
  let toml = "
title = \"Test\"
description = \"Test\"
author = \"Test\"
base_url = \"https://test.com\"
posts_per_page = 5

[social]
github = \"testuser\"
linkedin = \"testlinkedin\"
"

  let assert Ok(cfg) = config.parse(toml)
  let social = config.get_social(cfg)
  should.equal(social.github, Some("testuser"))
  should.equal(social.linkedin, Some("testlinkedin"))
}

pub fn parse_rss_config_test() {
  let toml = "
title = \"Test\"
description = \"Test\"
author = \"Test\"
base_url = \"https://test.com\"
posts_per_page = 5

[rss]
enabled = true
"

  let assert Ok(cfg) = config.parse(toml)
  should.equal(config.get_rss(cfg).enabled, True)
}

pub fn parse_rss_disabled_test() {
  let toml = "
title = \"Test\"
description = \"Test\"
author = \"Test\"
base_url = \"https://test.com\"
posts_per_page = 5

[rss]
enabled = false
"

  let assert Ok(cfg) = config.parse(toml)
  should.equal(config.get_rss(cfg).enabled, False)
}

pub fn parse_default_posts_per_page_test() {
  let toml = "
title = \"Test\"
description = \"Test\"
author = \"Test\"
base_url = \"https://test.com\"
"

  let assert Ok(cfg) = config.parse(toml)
  should.equal(cfg.posts_per_page, 10)  // default value
}

pub fn parse_missing_required_field_test() {
  let toml = "
description = \"A blog without a title\"
"

  let result = config.parse(toml)
  should.be_error(result)
}

pub fn parse_empty_nav_links_test() {
  let toml = "
title = \"Test\"
description = \"Test\"
author = \"Test\"
base_url = \"https://test.com\"
posts_per_page = 5
"

  let assert Ok(cfg) = config.parse(toml)
  should.equal(config.get_nav_links(cfg), [])
}

pub fn parse_empty_social_test() {
  let toml = "
title = \"Test\"
description = \"Test\"
author = \"Test\"
base_url = \"https://test.com\"
posts_per_page = 5
"

  let assert Ok(cfg) = config.parse(toml)
  let social = config.get_social(cfg)
  should.equal(social.github, None)
  should.equal(social.linkedin, None)
}

pub fn default_rss_enabled_test() {
  let toml = "
title = \"Test\"
description = \"Test\"
author = \"Test\"
base_url = \"https://test.com\"
"

  let assert Ok(cfg) = config.parse(toml)
  should.equal(config.get_rss(cfg).enabled, True)  // default to enabled
}
