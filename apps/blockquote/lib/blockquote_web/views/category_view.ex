defmodule BlockquoteWeb.CategoryView do
  use BlockquoteWeb, :view
  
  def render("new.html", assigns) do
    assigns = Map.merge(assigns, shared_form_assigns())
    render BlockquoteWeb.SharedView, "new.html", assigns
  end

  def render("edit.html", assigns) do
    assigns = Map.merge(assigns, 
      %{
        item: assigns[:category],
        item_display_name: to_s(assigns[:category])
      }
    ) |> Map.merge(shared_form_assigns())
    render BlockquoteWeb.SharedView, "edit.html", assigns
  end

  def shared_form_assigns() do
    %{
        required_fields: Blockquote.Admin.Category.required_fields(), 
        form_fields: form_fields()
      }
  end
  
  def to_s(category) do
    category.name
  end
  
  @doc """
  Maps a list of categories into tuples, used for forms
  """
  def map_for_form(categories) do
    Enum.map(categories, &{to_s(&1), &1.id})
  end
  
  def item_columns(_conn, category) do
    [
      {"name", category.name}, 
    ]
  end
  
  
  def form_fields() do
    [
      {:name, :string, nil},
    ]
  end
  
end
