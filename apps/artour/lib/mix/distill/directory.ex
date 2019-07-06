defmodule Distill.Directory do
  @doc """
  Default directory to store generated static site
  """
  def default_dest_directory() do
    [__DIR__, "..", "..", "..", "priv", "distilled"]
    |> Path.join
    |> Path.expand
  end
end
