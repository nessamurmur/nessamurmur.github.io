import gleam/io
import gleam/list
import polly

/// Error type for watcher operations
pub type WatchError {
  WatchFailed(String)
}

/// Start watching directories for changes
pub fn start(
  directories: List(String),
  on_change: fn(String) -> Nil,
) -> Result(polly.Watcher, WatchError) {
  let options =
    polly.new()
    |> add_directories(directories)
    |> polly.add_callback(fn(event) {
      io.println("File changed: " <> event.path)
      on_change(event.path)
    })

  case polly.watch(options) {
    Ok(watcher) -> Ok(watcher)
    Error(errors) -> Error(WatchFailed(polly.describe_errors(errors)))
  }
}

fn add_directories(
  options: polly.Options,
  directories: List(String),
) -> polly.Options {
  list.fold(directories, options, fn(opts, dir) { polly.add_dir(opts, dir) })
}

/// Stop the watcher
pub fn stop(watcher: polly.Watcher) -> Nil {
  polly.stop(watcher)
}
