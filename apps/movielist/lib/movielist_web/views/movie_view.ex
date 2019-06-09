defmodule MovielistWeb.MovieView do
  use MovielistWeb, :view

  def to_s(movie) do
  	movie.title
  end

  @doc """
  Maps a list of movies into tuples, used for forms
  """
  def map_for_form(movies) do
    Enum.map(movies, &{to_s(&1), &1.id})
  end

  @doc """
  String representation of active status
  """
  def is_active_status(is_active) do
    case is_active do
      true  -> "Active"
      false -> "Inactive"
    end
  end

  @doc """
  CSS class for button of movie show pages to change active status
  """
  def active_button_class(is_active) do
    case is_active do
      true  -> "btn-primary"
      false -> "btn-default"
    end
  end

  def row_class_for_active_status(is_active) do
    case is_active do
      true  -> "tr_primary"
      false -> "tr_error"
    end
  end

  def css_class_for_release_status(release_status) do
    case release_status do
      3 -> "tr_error"
      2 -> "tr_warning"
      1 -> "tr_primary"
    end
  end
end
