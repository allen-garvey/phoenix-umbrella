defmodule BlockquoteWeb.CategoryView do
  use BlockquoteWeb, :view
  
  Common.ViewHelpers.Form.define_map_for_form(true)
  
  def item_columns(_conn, category) do
    [
      {"name", category.name}, 
    ]
  end

  def form_action(conn, nil) do
    category_path(conn, :create)
  end

  def form_action(conn, category) do
    category_path(conn, :update, category)
  end
  
end
