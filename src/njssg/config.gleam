import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import tom.{type Toml}

pub type Config {
  Config(
    title: String,
    description: String,
    author: String,
    base_url: String,
    posts_per_page: Int,
    nav: NavConfig,
    social: SocialLinks,
    rss: RssConfig,
    author_config: AuthorConfig,
  )
}

pub type NavConfig {
  NavConfig(links: List(NavLink))
}

pub type NavLink {
  NavLink(title: String, url: String)
}

pub type SocialLinks {
  SocialLinks(
    github: Option(String),
    linkedin: Option(String),
    mastodon: Option(String),
    bluesky: Option(String),
  )
}

pub type RssConfig {
  RssConfig(enabled: Bool)
}

pub type AuthorConfig {
  AuthorConfig(
    avatar_url: Option(String),
    tagline: Option(String),
    extra_links: List(NavLink),
  )
}

pub type ConfigError {
  ParseError(String)
  MissingField(String)
}

pub fn parse(toml_string: String) -> Result(Config, ConfigError) {
  use parsed <- result.try(
    tom.parse(toml_string)
    |> result.map_error(fn(_e) { ParseError("Failed to parse TOML") }),
  )

  use title <- result.try(get_string(parsed, ["title"]))
  use description <- result.try(get_string(parsed, ["description"]))
  use author <- result.try(get_string(parsed, ["author"]))
  use base_url <- result.try(get_string(parsed, ["base_url"]))

  let posts_per_page =
    tom.get_int(parsed, ["posts_per_page"])
    |> result.unwrap(10)

  let nav = parse_nav(parsed)
  let social = parse_social(parsed)
  let rss = parse_rss(parsed)
  let author_config = parse_author_config(parsed)

  Ok(Config(
    title: title,
    description: description,
    author: author,
    base_url: base_url,
    posts_per_page: posts_per_page,
    nav: nav,
    social: social,
    rss: rss,
    author_config: author_config,
  ))
}

fn get_string(
  toml: Dict(String, Toml),
  key: List(String),
) -> Result(String, ConfigError) {
  tom.get_string(toml, key)
  |> result.map_error(fn(_) {
    MissingField(key |> list.last |> result.unwrap("unknown"))
  })
}

fn parse_inline_link(item: Toml) -> Result(NavLink, Nil) {
  case item {
    tom.InlineTable(table) -> {
      let title =
        dict.get(table, "title")
        |> result.try(fn(v) {
          case v {
            tom.String(s) -> Ok(s)
            _ -> Error(Nil)
          }
        })
      let url =
        dict.get(table, "url")
        |> result.try(fn(v) {
          case v {
            tom.String(s) -> Ok(s)
            _ -> Error(Nil)
          }
        })
      case title, url {
        Ok(t), Ok(u) -> Ok(NavLink(title: t, url: u))
        _, _ -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

fn parse_nav(toml: Dict(String, Toml)) -> NavConfig {
  let links = case tom.get_array(toml, ["nav", "links"]) {
    Ok(link_array) -> list.filter_map(link_array, parse_inline_link)
    Error(_) -> []
  }
  NavConfig(links: links)
}

fn parse_social(toml: Dict(String, Toml)) -> SocialLinks {
  let github = case tom.get_string(toml, ["social", "github"]) {
    Ok(s) -> Some(s)
    Error(_) -> None
  }
  let linkedin = case tom.get_string(toml, ["social", "linkedin"]) {
    Ok(s) -> Some(s)
    Error(_) -> None
  }
  let mastodon = case tom.get_string(toml, ["social", "mastodon"]) {
    Ok(s) -> Some(s)
    Error(_) -> None
  }
  let bluesky = case tom.get_string(toml, ["social", "bluesky"]) {
    Ok(s) -> Some(s)
    Error(_) -> None
  }
  SocialLinks(
    github: github,
    linkedin: linkedin,
    mastodon: mastodon,
    bluesky: bluesky,
  )
}

fn parse_rss(toml: Dict(String, Toml)) -> RssConfig {
  let enabled = case tom.get_bool(toml, ["rss", "enabled"]) {
    Ok(b) -> b
    Error(_) -> True
    // default to enabled
  }
  RssConfig(enabled: enabled)
}

fn parse_author_config(toml: Dict(String, Toml)) -> AuthorConfig {
  let avatar_url = case tom.get_string(toml, ["author_config", "avatar_url"]) {
    Ok(s) -> Some(s)
    Error(_) -> None
  }
  let tagline = case tom.get_string(toml, ["author_config", "tagline"]) {
    Ok(s) -> Some(s)
    Error(_) -> None
  }
  let extra_links = case tom.get_array(toml, ["author_config", "extra_links"]) {
    Ok(arr) -> list.filter_map(arr, parse_inline_link)
    Error(_) -> []
  }
  AuthorConfig(
    avatar_url: avatar_url,
    tagline: tagline,
    extra_links: extra_links,
  )
}

pub fn get_nav_links(config: Config) -> List(NavLink) {
  config.nav.links
}

pub fn get_social(config: Config) -> SocialLinks {
  config.social
}

pub fn get_rss(config: Config) -> RssConfig {
  config.rss
}
