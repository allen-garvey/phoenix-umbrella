defmodule BlockquoteWeb.SourceTypeView do
  use BlockquoteWeb, :view
  
  Common.ViewHelpers.Form.define_map_for_form(true)
  
  def item_columns(_conn, source_type) do
    [
      {"name", source_type.name}, 
    ]
  end

  def form_action(conn, nil) do
    source_type_path(conn, :create)
  end

  def form_action(conn, source_type) do
    source_type_path(conn, :update, source_type)
  end
end
