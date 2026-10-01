import collections
import generator
import gleam/int
import gleam/io
import gleam/list
import simplifile

pub fn main() -> Nil {
  prepare_output()

  let loaded_collections =
    collections.all()
    |> generator.load_collections

  let shortcodes = generator.collection_shortcodes(loaded_collections)
  let route_sources = generator.load_routes()

  generator.build_routes(route_sources, shortcodes, loaded_collections)
  generator.build_collections(loaded_collections, shortcodes)
  generator.build_tags(loaded_collections)
  generator.write_discovery_files(route_sources, loaded_collections)

  copy_static_assets()
  print_build_summary(route_sources, loaded_collections)
}

fn prepare_output() -> Nil {
  let assert Ok(Nil) = simplifile.create_directory_all("dist")
  let assert Ok(Nil) = simplifile.clear_directory(at: "dist")
  Nil
}

fn copy_static_assets() -> Nil {
  let assert Ok(Nil) =
    simplifile.copy_directory(at: "assets/static", to: "dist/assets")
  Nil
}

fn print_build_summary(
  route_sources: List(String),
  loaded_collections: List(generator.LoadedCollection),
) -> Nil {
  io.println(
    "Generated "
    <> int.to_string(list.length(route_sources))
    <> " routes, "
    <> int.to_string(generator.item_count(loaded_collections))
    <> " collection items, "
    <> int.to_string(generator.tag_count(loaded_collections))
    <> " tag archives, a tag index, and static assets in dist/",
  )
}
