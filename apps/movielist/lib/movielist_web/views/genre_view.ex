defmodule MovielistWeb.GenreView do
  use MovielistWeb, :view

  def to_s(genre) do
  	genre.name
  end

  @doc """
  Maps a list of genres into tuples, used for forms
  """
  def map_for_form(genres) do
    Enum.map(genres, &{to_s(&1), &1.id})
  end
  
end
