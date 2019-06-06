defmodule BooklistWeb.LibraryView do
  use BooklistWeb, :view

  def to_s(library) do
  	library.name
  end

  @doc """
  Maps a list of libraries into tuples, used for forms
  """
  def map_for_form(libraries) do
    Enum.map(libraries, &{to_s(&1), &1.id})
  end
end
