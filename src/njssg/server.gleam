import gleam/bytes_tree
import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/io
import gleam/list
import gleam/string
import mist
import simplifile

/// Start the development server
pub fn start(public_dir: String, port: Int) -> Result(Nil, String) {
  let handler = fn(req: Request(mist.Connection)) {
    handle_request(req, public_dir)
  }

  io.println("Starting dev server at http://localhost:" <> string.inspect(port))
  io.println("Serving files from: " <> public_dir)
  io.println("Press Ctrl+C to stop")

  let assert Ok(_) =
    mist.new(handler)
    |> mist.port(port)
    |> mist.start

  // Keep the process running
  process.sleep_forever()

  Ok(Nil)
}

fn handle_request(
  req: Request(mist.Connection),
  public_dir: String,
) -> Response(mist.ResponseData) {
  let path = req.path

  // Clean up path
  let file_path = case path {
    "/" -> public_dir <> "/index.html"
    p -> {
      // Check if path ends with / and add index.html
      case string.ends_with(p, "/") {
        True -> public_dir <> p <> "index.html"
        False -> {
          // Check if it's a directory by trying to read index.html
          let dir_path = public_dir <> p <> "/index.html"
          case simplifile.is_file(dir_path) {
            Ok(True) -> dir_path
            _ -> public_dir <> p
          }
        }
      }
    }
  }

  case simplifile.read(file_path) {
    Ok(content) -> {
      let content_type = get_content_type(file_path)
      response.new(200)
      |> response.set_header("content-type", content_type)
      |> response.set_body(mist.Bytes(bytes_tree.from_string(content)))
    }
    Error(_) -> {
      // Try with .html extension
      case simplifile.read(file_path <> ".html") {
        Ok(content) ->
          response.new(200)
          |> response.set_header("content-type", "text/html; charset=utf-8")
          |> response.set_body(mist.Bytes(bytes_tree.from_string(content)))
        Error(_) ->
          response.new(404)
          |> response.set_header("content-type", "text/html; charset=utf-8")
          |> response.set_body(
            mist.Bytes(bytes_tree.from_string("<h1>404 Not Found</h1>")),
          )
      }
    }
  }
}

fn get_content_type(path: String) -> String {
  let ext = get_extension(path)
  case ext {
    "html" -> "text/html; charset=utf-8"
    "css" -> "text/css; charset=utf-8"
    "js" -> "application/javascript; charset=utf-8"
    "json" -> "application/json; charset=utf-8"
    "xml" -> "application/xml; charset=utf-8"
    "png" -> "image/png"
    "jpg" -> "image/jpeg"
    "jpeg" -> "image/jpeg"
    "gif" -> "image/gif"
    "svg" -> "image/svg+xml"
    "ico" -> "image/x-icon"
    "woff" -> "font/woff"
    "woff2" -> "font/woff2"
    _ -> "application/octet-stream"
  }
}

fn get_extension(path: String) -> String {
  case string.split(path, ".") {
    [] -> ""
    parts -> {
      case list.last(parts) {
        Ok(ext) -> ext
        Error(_) -> ""
      }
    }
  }
}
