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
  
  def to_s(source_type) do
    source_type.name
  end
  
  @doc """
  Maps a list of source types into tuples, used for forms
  """
  def map_for_form(source_types) do
    Enum.map(source_types, &{to_s(&1), &1.id})
  end
  
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
