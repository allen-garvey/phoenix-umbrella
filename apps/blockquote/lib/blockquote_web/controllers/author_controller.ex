defmodule BlockquoteWeb.AuthorController do
  use BlockquoteWeb, :controller

  alias Blockquote.Admin
  alias Blockquote.Admin.Author

  def custom_render(conn, template, assigns) do
    custom_render(conn, view_module(conn), template, assigns)
  end

  def custom_render(conn, view_module, template, assigns) do
    assigns = [{:item_name_singular, "author"}] ++ assigns
    render(conn, view_module, template, assigns)
  end

  def index(conn, _params) do
    authors = Admin.list_authors()
    custom_render(conn, BlockquoteWeb.SharedView, "index.html", items: authors, item_view: view_module(conn), item_display_func: :to_sorted_name)
  end

  def new(conn, _params) do
    changeset = Admin.change_author(%Author{})
    custom_render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"author" => author_params}) do
    case Admin.create_author(author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author created successfully.")
        |> redirect(to: author_path(conn, :show, author))
      {:error, %Ecto.Changeset{} = changeset} ->
        custom_render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    author = Admin.get_author_for_show!(id)
    custom_render(conn, "show.html", author: author)
  end

  def edit(conn, %{"id" => id}) do
    author = Admin.get_author!(id)
    changeset = Admin.change_author(author)
    custom_render(conn, "edit.html", author: author, changeset: changeset)
  end

  def update(conn, %{"id" => id, "author" => author_params}) do
    author = Admin.get_author!(id)

    case Admin.update_author(author, author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author updated successfully.")
        |> redirect(to: author_path(conn, :show, author))
      {:error, %Ecto.Changeset{} = changeset} ->
        custom_render(conn, "edit.html", author: author, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    author = Admin.get_author!(id)
    {:ok, _author} = Admin.delete_author(author)

    conn
    |> put_flash(:info, "Author deleted successfully.")
    |> redirect(to: author_path(conn, :index))
  end
end
