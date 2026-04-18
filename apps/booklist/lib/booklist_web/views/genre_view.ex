defmodule BooklistWeb.GenreView do
  use BooklistWeb, :view

  Common.ViewHelpers.Form.define_map_for_form(true)

  def show_path(genre) do
    ~p"/genres/#{genre}"
  end

  @doc """
  Maps a list of genres into hashmap, used for adding book form
  to prefill is_fiction field
  """
  def to_is_fiction_map(genres) do
    Map.new(genres, &{&1.id, &1.is_fiction})
  end

  def sort_link(genre_id, current_sort) when is_atom(current_sort) do
    case current_sort do
      :new ->
        link("Sort by rating",
          to: ~p"/genres/#{genre_id}?sort=score",
          class: "btn btn-sm btn-default"
        )

      :score ->
        link("Sort by new",
          to: ~p"/genres/#{genre_id}?sort=new",
          class: "btn btn-sm btn-default"
        )
    end
  end
end
