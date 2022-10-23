defmodule PluginistaWeb.CategoryView do
  use PluginistaWeb, :view

  Common.ViewHelpers.Form.define_map_for_form_default()

  @doc """
  Maps a list of categories into list of maps, used on plugin form
  """
  def to_json(categories) do
    categories
    |> Enum.map(&%{:id => &1.id, :name => &1.name, :group_id => &1.group_id})
    |> Jason.encode!
  end

  @doc """
  Gets CSS class for category for plugin table
  """
  def category_class(nil) do
    ""
  end
  
  def category_class(category) do
    colors = [
      "blue",
      "teal",
      "magenta",
      "yellow",
      "orange",
      "green",
      "red",
      "cyan",
      "lime",
      "bordeaux",
      "violet",
      "black",
    ]
    
    "row-#{Enum.at(colors, rem(category.id, Enum.count(colors)))}"
  end
end
