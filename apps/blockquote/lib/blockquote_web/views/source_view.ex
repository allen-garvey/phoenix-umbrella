defmodule BlockquoteWeb.SourceView do
  use BlockquoteWeb, :view

  def index_path do
    ~p"/sources"
  end

  def new_path do
    ~p"/sources/new"
  end

  def show_path(source) do
    ~p"/sources/#{source}"
  end

  def edit_path(source) do
    ~p"/sources/#{source}/edit"
  end

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

  def item_columns(source) do
    parent_source_link =
      case is_nil(source.parent_source) do
        false ->
          link(BlockquoteWeb.ParentSourceView.to_s(source.parent_source),
            to: BlockquoteWeb.ParentSourceView.show_path(source.parent_source)
          )

        true ->
          nil
      end

    [
      {"title", source.title},
      {"subtitle", source.subtitle},
      {"author",
       link(BlockquoteWeb.AuthorView.to_s(source.author),
         to: BlockquoteWeb.AuthorView.show_path(source.author)
       )},
      {"source type",
       link(BlockquoteWeb.SourceTypeView.to_s(source.source_type),
         to: BlockquoteWeb.SourceTypeView.show_path(source.source_type)
       )},
      {"parent source", parent_source_link},
      {"url", BlockquoteWeb.SharedView.linkify(source.url)},
      {"release date", source.release_date}
    ]
  end

  def form_action(nil) do
    index_path()
  end

  def form_action(source) do
    show_path(source)
  end

  def show_buttons(source) do
    [
      %BlockquoteWeb.Link{title: "Add quote", path: ~p"/quotes/new?source=#{source.id}"}
    ]
  end
end
