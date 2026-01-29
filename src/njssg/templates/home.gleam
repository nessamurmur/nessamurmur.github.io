import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html.{div}
import njssg/config.{type Config}
import njssg/templates/components

pub fn render(config: Config) -> Element(msg) {
  div([class("home-page")], [
    components.author_bio(config),
  ])
}
