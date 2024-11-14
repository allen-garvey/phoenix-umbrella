defmodule BlockquoteWeb.ParentSourceController do
  use BlockquoteWeb, :controller

  alias Blockquote.Admin
  alias Blockquote.Admin.ParentSource

  defp custom_render(conn, template, assigns) do
    assigns = [
      item_name_singular: "parent source", 
      breadcrumb: {"Parent sources", parent_source_path(conn, :index)}
    ] ++ assigns
    render(conn, template, assigns)
  end

  defp related_fields do
    source_types = Admin.list_source_types() |> BlockquoteWeb.SourceTypeView.map_for_form

    [source_types: source_types]
  end

  def index(conn, _params) do
    parent_sources = Admin.list_parent_sources()
    custom_render(conn, "index.html", parent_sources: parent_sources)
  end

  defp new_page(conn, changeset) do
    custom_render(conn, "form.html", changeset: changeset, related_fields: related_fields())
  end

  defp edit_page(conn, changeset, parent_source) do
    custom_render(conn, "form.html", changeset: changeset, related_fields: related_fields(), parent_source: parent_source)
  end

  def new(conn, _params) do
    changeset = Admin.change_parent_source(%ParentSource{})
    new_page(conn, changeset)
  end

  def create(conn, %{"parent_source" => parent_source_params}) do
    case Admin.create_parent_source(parent_source_params) do
      {:ok, parent_source} ->
        conn
        |> put_flash(:info, "Parent source created successfully.")
        |> redirect(to: parent_source_path(conn, :show, parent_source))
      {:error, %Ecto.Changeset{} = changeset} ->
        new_page(conn, changeset)
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
