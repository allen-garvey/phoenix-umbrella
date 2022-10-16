defmodule PluginistaWeb.CategoryView do
  use PluginistaWeb, :view

  @doc """
  Maps a list of categories into tuples, used for forms
  """
  def map_for_form(categories) do
    Enum.map(categories, &{&1.name, &1.id})
  end
end
