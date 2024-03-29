#run task with 'mix distill.statc'
defmodule Mix.Tasks.Distill.Static do
  use Mix.Task

  @shortdoc "Copies static assets to distill directory. Make sure to run `npm run deploy` first."
  def run(_args) do
    dest_dir = Distill.Directory.default_dest_directory
    #create root directory if it doesn't exist
    File.mkdir_p! dest_dir

    source_dir = default_static_assets_directory()

    IO.puts "\nCopying static assets\n"

    static_asset_filenames()
    |> Enum.map(fn filename ->
      dest_enclosing_dir = Path.join(dest_dir, Path.dirname(filename))
      #make sure enclosing directory in dest_dir exists
      File.mkdir_p! dest_enclosing_dir

      source_full_filename = Path.join(source_dir, filename)
      dest_full_filename = Path.join(dest_dir, filename)

      File.cp source_full_filename, dest_full_filename
    end)
  end

  @doc """
  Default directory for static assets
  """
  def default_static_assets_directory() do
    [__DIR__, "..", "..", "..", "priv", "static"]
    |> Path.join
    |> Path.expand
  end

  @doc """
  Returns list of filenames of static assets
  """
  def static_asset_filenames() do
    [
      "favicon.ico",
      "robots.txt",
      Path.join("assets", "app.css"),
      Path.join("assets", "app.js"),
    ]
  end



end
