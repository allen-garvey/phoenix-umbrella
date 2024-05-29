defmodule BlockquoteWeb.ParentSourceView do
  use BlockquoteWeb, :view

  alias BlockquoteWeb.Link
  
  def render("new.html", assigns) do
    assigns = Map.merge(assigns, shared_form_assigns(assigns))
    render BlockquoteWeb.SharedView, "new.html", assigns
  end

  def render("edit.html", assigns) do
    assigns = Map.merge(assigns, 
      %{
        item_display_name: to_s(assigns[:item])
      }
    ) |> Map.merge(shared_form_assigns(assigns))
    render BlockquoteWeb.SharedView, "edit.html", assigns
  end

  def shared_form_assigns(assigns) do
    %{
        required_fields: Blockquote.Admin.ParentSource.required_fields(), 
        form_fields: form_fields(assigns[:related_fields])
      }
  end
  
  def to_s(parent_source) do
    to_s(parent_source.title, parent_source.subtitle)
  end
  
  def to_s(title, nil) do
    title
  end
  
  def to_s(title, subtitle) do
    title <> ": " <> subtitle
  end
  
  
  Common.ViewHelpers.Form.define_map_for_form()
  
  def item_columns(conn, parent_source) do
    [
      {"title", parent_source.title},
      {"subtitle", parent_source.subtitle},
      {"source type", link(BlockquoteWeb.SourceTypeView.to_s(parent_source.source_type), to: source_type_path(conn, :show, parent_source.source_type))},
      {"url", BlockquoteWeb.SharedView.linkify(parent_source.url)}, 
    ]
  end
  
  
  def form_fields(related_fields) do
    [
      {:title, :string, nil},
      {:subtitle, :string, nil},
      {:source_type_id, :select, related_fields[:source_types]},
      {:url, :string, nil},
    ]
  end

  def show_buttons(conn, parent_source) do
    [
      %Link{title: "Add source", path: source_path(conn, :new, parent_source: parent_source.id)}
    ]
  end
end
