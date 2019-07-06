#run task with 'mix distill.statc'
defmodule Mix.Tasks.Distill.Static do
  use Mix.Task

  @shortdoc "Runs npm build script and copies static assets to given directory"
  def run(_args) do
    IO.puts "Running npm production build script"
    {_, 0} = System.cmd("npm", ["run", "deploy"], into: IO.stream(:stdio, :line))


    dest_dir = Distill.Directory.default_dest_directory
    #create root directory if it doesn't exist
    File.mkdir_p! dest_dir

    source_dir = default_static_assets_directory()

    IO.puts "\nCopying static assets\n"

    for filename <- static_asset_filenames() do
      dest_enclosing_dir = Path.join(dest_dir, Path.dirname(filename))
      #make sure enclosing directory in dest_dir exists
      File.mkdir_p! dest_enclosing_dir

      source_full_filename = Path.join(source_dir, filename)
      dest_full_filename = Path.join(dest_dir, filename)

      IO.puts "Copying #{source_full_filename} -> #{dest_full_filename}"

      File.cp source_full_filename, dest_full_filename
    end

  end

  @doc """
  Default directory for static assets
  """
  def default_static_assets_directory() do
    File.cwd!
      |> Path.join("priv")
      |> Path.join("static")
  end

  @doc """
  Returns list of filenames of static assets
  """
  def static_asset_filenames() do
    [
      "favicon.ico",
      "robots.txt",
      Path.join("css", "app.css"),
      Path.join("js", "app.min.js"),
    ]
  end



end
