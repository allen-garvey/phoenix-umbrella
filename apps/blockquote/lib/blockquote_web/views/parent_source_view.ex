defmodule BlockquoteWeb.ParentSourceView do
  use BlockquoteWeb, :view

  def index_path do
    ~p"/parent-sources"
  end

  def new_path do
    ~p"/parent-sources/new"
  end

  def show_path(parent_source) do
    ~p"/parent-sources/#{parent_source}"
  end

  def edit_path(parent_source) do
    ~p"/parent-sources/#{parent_source}/edit"
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

  def item_columns(parent_source) do
    [
      {"title", parent_source.title},
      {"subtitle", parent_source.subtitle},
      {"source type",
       link(BlockquoteWeb.SourceTypeView.to_s(parent_source.source_type),
         to: BlockquoteWeb.SourceTypeView.show_path(parent_source.source_type)
       )},
      {"url", BlockquoteWeb.SharedView.linkify(parent_source.url)}
    ]
  end

  def form_action(nil) do
    index_path()
  end

  def form_action(parent_source) do
    show_path(parent_source)
  end

  def show_buttons(parent_source) do
    [
      %BlockquoteWeb.Link{
        title: "Add source",
        path: ~p"/sources/new?parent_source=#{parent_source.id}"
      }
    ]
  end
end
