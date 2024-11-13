defmodule BlockquoteWeb.ParentSourceView do
  use BlockquoteWeb, :view
  
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

  def form_action(conn, nil) do
    parent_source_path(conn, :create)
  end

  def form_action(conn, parent_source) do
    parent_source_path(conn, :update, parent_source)
  end

  def show_buttons(conn, parent_source) do
    [
      %BlockquoteWeb.Link{title: "Add source", path: source_path(conn, :new, parent_source: parent_source.id)}
    ]
  end
end
