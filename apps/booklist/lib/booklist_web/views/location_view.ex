defmodule BooklistWeb.LocationView do
  use BooklistWeb, :view

  def to_s_full(location) do
  	BooklistWeb.LibraryView.to_s(location.library) <> "—" <> location.name
  end

  def to_s(location) do
  	location.name
  end

  @doc """
  Maps a list of locations into tuples, used for forms
  """
  def map_for_form(locations) do
    Enum.map(locations, &{to_s_full(&1), &1.id})
  end
end
