defmodule MovielistWeb.GenreView do
  use MovielistWeb, :view

  def to_s(genre) do
  	genre.name
  end

  Common.ViewHelpers.Form.define_map_for_form()
end
