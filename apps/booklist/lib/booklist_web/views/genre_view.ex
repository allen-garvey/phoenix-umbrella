defmodule BooklistWeb.GenreView do
  use BooklistWeb, :view

  def to_s(genre) do
  	genre.name
  end

  @doc """
  Maps a list of genres into tuples, used for forms
  """
  def map_for_form(genres) do
    Enum.map(genres, &{to_s(&1), &1.id})
  end

  @doc """
  Maps a list of genres into hashmap, used for adding book form
  to prefill is_fiction field
  """
  def to_is_fiction_map(genres) do
    Map.new(genres, &{&1.id, &1.is_fiction})
  end
end
