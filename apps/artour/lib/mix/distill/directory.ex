defmodule Distill.Directory do
  @doc """
  Default directory to store generated static site
  """
  def default_dest_directory() do
    File.cwd! |> Path.join("priv") |> Path.join("distilled")
  end
end