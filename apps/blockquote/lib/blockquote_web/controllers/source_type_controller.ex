defmodule BlockquoteWeb.SourceTypeController do
  use BlockquoteWeb, :controller

  alias Blockquote.Admin
  alias Blockquote.Admin.SourceType

  def custom_render(conn, template, assigns) do
    custom_render(conn, view_module(conn), template, assigns)
  end

  def custom_render(conn, view_module, template, assigns) do
    assigns = [{:item_name_singular, "source type"}] ++ assigns
    render(conn, view_module, template, assigns)
  end

  def index(conn, _params) do
    source_types = Admin.list_source_types()
    custom_render(conn, BlockquoteWeb.SharedView, "index.html", items: source_types, item_view: view_module(conn), item_display_func: :to_s)
  end

  def new(conn, _params) do
    changeset = Admin.change_source_type(%SourceType{})
    custom_render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"source_type" => source_type_params}) do
    case Admin.create_source_type(source_type_params) do
      {:ok, source_type} ->
        conn
        |> put_flash(:info, "Source type created successfully.")
        |> redirect(to: source_type_path(conn, :show, source_type))
      {:error, %Ecto.Changeset{} = changeset} ->
        custom_render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    source_type = Admin.get_source_type_for_show!(id)
    custom_render(conn, "show.html", source_type: source_type)
  end

  def edit(conn, %{"id" => id}) do
    source_type = Admin.get_source_type!(id)
    changeset = Admin.change_source_type(source_type)
    custom_render(conn, "edit.html", source_type: source_type, changeset: changeset)
  end

  def update(conn, %{"id" => id, "source_type" => source_type_params}) do
    source_type = Admin.get_source_type!(id)

    case Admin.update_source_type(source_type, source_type_params) do
      {:ok, source_type} ->
        conn
        |> put_flash(:info, "Source type updated successfully.")
        |> redirect(to: source_type_path(conn, :show, source_type))
      {:error, %Ecto.Changeset{} = changeset} ->
        custom_render(conn, "edit.html", source_type: source_type, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    source_type = Admin.get_source_type!(id)
    {:ok, _source_type} = Admin.delete_source_type(source_type)

    conn
    |> put_flash(:info, "Source type deleted successfully.")
    |> redirect(to: source_type_path(conn, :index))
  end
end
