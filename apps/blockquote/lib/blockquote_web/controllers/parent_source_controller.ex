defmodule BlockquoteWeb.ParentSourceController do
  use BlockquoteWeb, :controller

  alias Blockquote.Admin
  alias Blockquote.Admin.ParentSource
  
  def custom_render(conn, template, assigns) do
    custom_render(conn, view_module(conn), template, assigns)
  end

  def custom_render(conn, view_module, template, assigns) do
    assigns = [{:item_name_singular, "parent source"}] ++ assigns
    render(conn, view_module, template, assigns)
  end

  def related_fields do
    source_types = Admin.list_source_types() |> BlockquoteWeb.SourceTypeView.map_for_form
    
    [source_types: source_types]
  end

  def index(conn, _params) do
    parent_sources = Admin.list_parent_sources()
    custom_render(conn, BlockquoteWeb.SharedView, "index.html", items: parent_sources, item_view: view_module(conn), item_display_func: :to_s)
  end
  
  def new_page(conn, changeset, _params) do
    custom_render(conn, "new.html", changeset: changeset, related_fields: related_fields())
  end
  
  def edit_page(conn, changeset, parent_source) do
    custom_render(conn, "edit.html", changeset: changeset, related_fields: related_fields(), item: parent_source)
  end

  def new(conn, params) do
    changeset = Admin.change_parent_source(%ParentSource{})
    new_page(conn, changeset, params)
  end

  def create(conn, %{"parent_source" => parent_source_params}) do
    case Admin.create_parent_source(parent_source_params) do
      {:ok, parent_source} ->
        conn
        |> put_flash(:info, "Parent source created successfully.")
        |> redirect(to: parent_source_path(conn, :show, parent_source))
      {:error, %Ecto.Changeset{} = changeset} ->
        new_page(conn, changeset, nil)
    end
  end

  def show(conn, %{"id" => id}) do
    parent_source = Admin.get_parent_source_for_show!(id)
    custom_render(conn, "show.html", parent_source: parent_source)
  end

  def edit(conn, %{"id" => id}) do
    parent_source = Admin.get_parent_source!(id)
    changeset = Admin.change_parent_source(parent_source)
    edit_page(conn, changeset, parent_source)
  end

  def update(conn, %{"id" => id, "parent_source" => parent_source_params}) do
    parent_source = Admin.get_parent_source!(id)

    case Admin.update_parent_source(parent_source, parent_source_params) do
      {:ok, parent_source} ->
        conn
        |> put_flash(:info, "Parent source updated successfully.")
        |> redirect(to: parent_source_path(conn, :show, parent_source))
      {:error, %Ecto.Changeset{} = changeset} ->
        edit_page(conn, changeset, parent_source)
    end
  end

  def delete(conn, %{"id" => id}) do
    parent_source = Admin.get_parent_source!(id)
    {:ok, _parent_source} = Admin.delete_parent_source(parent_source)

    conn
    |> put_flash(:info, "Parent source deleted successfully.")
    |> redirect(to: parent_source_path(conn, :index))
  end
end
