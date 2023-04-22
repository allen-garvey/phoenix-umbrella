defmodule PluginistaWeb.CategoryView do
  use PluginistaWeb, :view

  Common.ViewHelpers.Form.define_map_for_form(true)

  @doc """
  Maps a list of categories into list of maps, used on plugin form
  """
  def to_json(categories) do
    categories
    |> Enum.map(&%{:id => &1.id, :name => &1.name, :group_id => &1.group_id})
    |> Jason.encode!
  end

end
