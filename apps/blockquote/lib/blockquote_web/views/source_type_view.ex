defmodule BlockquoteWeb.SourceTypeView do
  use BlockquoteWeb, :view
  
  def render("new.html", assigns) do
    assigns = Map.merge(assigns, shared_form_assigns())
    render BlockquoteWeb.SharedView, "new.html", assigns
  end

  def render("edit.html", assigns) do
    assigns = Map.merge(assigns, 
      %{
        item: assigns[:source_type],
        item_display_name: to_s(assigns[:source_type])
      }
    ) |> Map.merge(shared_form_assigns())
    render BlockquoteWeb.SharedView, "edit.html", assigns
  end

  def shared_form_assigns() do
    %{
        required_fields: Blockquote.Admin.SourceType.required_fields(), 
        form_fields: form_fields()
      }
  end
  
  Common.ViewHelpers.Form.define_map_for_form(true)
  
  def item_columns(_conn, source_type) do
    [
      {"name", source_type.name}, 
    ]
  end
  
  
  def form_fields() do
    [
      {:name, :string, nil},
    ]
  end
end
