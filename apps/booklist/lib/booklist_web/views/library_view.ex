defmodule BooklistWeb.LibraryView do
  use BooklistWeb, :view

  def to_s(library) do
  	library.name
  end

  Common.ViewHelpers.Form.define_map_for_form()
end
