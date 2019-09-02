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
    Enum.reduce(locations, %{}, fn location, locations_map ->
      library_title = BooklistWeb.LibraryView.to_s(location.library)
      locations_list = Map.get(locations_map, library_title, []) ++ [{to_s(location), location.id}]
      Map.put(locations_map, library_title, locations_list)
    end)
  end
end
