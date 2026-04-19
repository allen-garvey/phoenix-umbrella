defmodule BlockquoteWeb.SourceTypeView do
  use BlockquoteWeb, :view

  Common.ViewHelpers.Form.define_map_for_form(true)

  def index_path do
    ~p"/source-types"
  end

  def new_path do
    ~p"/source-types/new"
  end

  def show_path(source_type) do
    ~p"/source-types/#{source_type}"
  end

  def edit_path(source_type) do
    ~p"/source-types/#{source_type}/edit"
  end

  def item_columns(source_type) do
    [
      {"name", source_type.name}
    ]
  end

  def form_action(nil) do
    index_path()
  end

  def form_action(source_type) do
    show_path(source_type)
  end
end
