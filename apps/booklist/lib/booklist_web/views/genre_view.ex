defmodule BooklistWeb.GenreView do
  use BooklistWeb, :view

  Common.ViewHelpers.Form.define_map_for_form(true)

  @doc """
  Maps a list of genres into hashmap, used for adding book form
  to prefill is_fiction field
  """
  def to_is_fiction_map(genres) do
    Map.new(genres, &{&1.id, &1.is_fiction})
  end
end
