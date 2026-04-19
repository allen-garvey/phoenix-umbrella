defmodule BlockquoteWeb.CategoryView do
  use BlockquoteWeb, :view

  Common.ViewHelpers.Form.define_map_for_form(true)

  def index_path do
    ~p"/categories"
  end

  def new_path do
    ~p"/categories/new"
  end

  def show_path(category) do
    ~p"/categories/#{category}"
  end

  def edit_path(category) do
    ~p"/categories/#{category}/edit"
  end

  def item_columns(category) do
    [
      {"name", category.name}
    ]
  end

  def form_action(nil) do
    index_path()
  end

  def form_action(category) do
    show_path(category)
  end
end
