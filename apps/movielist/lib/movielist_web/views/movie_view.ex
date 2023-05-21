defmodule MovielistWeb.MovieView do
  use MovielistWeb, :view

  def to_s(movie) do
  	to_s(movie.title, movie.subtitle)
  end

  def to_s(title, nil) do
    title
  end

  def to_s(title, subtitle) do
    title <> ": " <> subtitle
  end

  Common.ViewHelpers.Form.define_map_for_form()

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
      false -> "btn-light"
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
      :home_released    -> "tr_primary"
      :theater_released -> "tr_warning"
      _                 -> "tr_error"
    end
  end

  def search_query_for_release_status(movie_title, :theater_released, nil) do
    "#{movie_title} digital release date"
  end

  def search_query_for_release_status(movie_title, _release_status, _home_release_date) do
    movie_title
  end

  def css_class_for_release_date(:theater_released, nil) do
    "release-date--calculated"
  end

  def css_class_for_release_date(_movie_release_status, _movie_home_release_date) do
    ""
  end

  def format_length(nil) do
    ""
  end

  def format_length(length) do
    "#{div(length, 60)}h #{rem(length, 60)}m"
  end
end
