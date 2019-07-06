defmodule Artour.LayoutView do
  use Artour.Web, :view

  def main_container_class(nil) do
    "container"
  end

  def main_container_class(s) when is_binary(s) do
    s
  end
end
