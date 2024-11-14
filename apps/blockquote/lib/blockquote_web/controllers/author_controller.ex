defmodule BlockquoteWeb.AuthorController do
  use BlockquoteWeb, :controller

  alias Blockquote.Admin
  alias Blockquote.Admin.Author

  defp custom_render(conn, template, assigns) do
    assigns = [
      item_name_singular: "author", 
      breadcrumb: {"Authors", author_path(conn, :index)}
    ] ++ assigns
    render(conn, template, assigns)
  end

  def index(conn, _params) do
    authors = Admin.list_authors()
    custom_render(conn, "index.html", authors: authors)
  end

  def new(conn, _params) do
    changeset = Admin.change_author(%Author{})
    custom_render(conn, "form.html", changeset: changeset)
  end

  def create(conn, %{"author" => author_params}) do
    case Admin.create_author(author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author created successfully.")
        |> redirect(to: author_path(conn, :show, author))
      {:error, %Ecto.Changeset{} = changeset} ->
        custom_render(conn, "form.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    author = Admin.get_author_for_show!(id)
    custom_render(conn, "show.html", author: author)
  end

  def edit(conn, %{"id" => id}) do
    author = Admin.get_author!(id)
    changeset = Admin.change_author(author)
    custom_render(conn, "form.html", author: author, changeset: changeset)
  end

  def update(conn, %{"id" => id, "author" => author_params}) do
    author = Admin.get_author!(id)

    case Admin.update_author(author, author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author updated successfully.")
        |> redirect(to: author_path(conn, :show, author))
      {:error, %Ecto.Changeset{} = changeset} ->
        custom_render(conn, "form.html", author: author, changeset: changeset)
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
