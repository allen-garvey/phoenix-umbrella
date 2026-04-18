defmodule BooklistWeb.LibraryView do
  use BooklistWeb, :view

  Common.ViewHelpers.Form.define_map_for_form(true)

  def show_path(library) do
    ~p"/libraries/#{library}"
  end
end
