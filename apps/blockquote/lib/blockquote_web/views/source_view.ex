defmodule BlockquoteWeb.SourceView do
  use BlockquoteWeb, :view
  
  def to_s(source) do
    to_s(source.title, source.subtitle)
  end
  
  def to_s(title, nil) do
    title
  end
  
  def to_s(title, subtitle) do
    title <> ": " <> subtitle
  end
  
  Common.ViewHelpers.Form.define_map_for_form()
  
  def item_columns(conn, source) do
    parent_source_link = case is_nil(source.parent_source) do
      false ->
        link(BlockquoteWeb.ParentSourceView.to_s(source.parent_source), to: parent_source_path(conn, :show, source.parent_source))
      true ->
        nil
    end
    
    [
      {"title", source.title},
      {"subtitle", source.subtitle},
      {"author", link(BlockquoteWeb.AuthorView.to_s(source.author), to: author_path(conn, :show, source.author))},
      {"source type", link(BlockquoteWeb.SourceTypeView.to_s(source.source_type), to: source_type_path(conn, :show, source.source_type))},
      {"parent source", parent_source_link},
      {"url", BlockquoteWeb.SharedView.linkify(source.url)},
      {"release date", source.release_date}, 
    ]
  end

  def form_action(conn, nil) do
    source_path(conn, :create)
  end

  def form_action(conn, source) do
    source_path(conn, :update, source)
  end

  def show_buttons(conn, source) do
    [
      %BlockquoteWeb.Link{title: "Add quote", path: quote_path(conn, :new, source: source.id)}
    ]
  end
end
