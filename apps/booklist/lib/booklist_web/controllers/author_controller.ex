defmodule BooklistWeb.AuthorController do
  use BooklistWeb, :controller

  alias Booklist.Admin
  alias Booklist.Admin.Author

  def index(conn, _params) do
    authors = Admin.list_authors()
    render(conn, "index.html", authors: authors)
  end

  def new(conn, _params) do
    changeset = Admin.change_author(%Author{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"author" => author_params}) do
    case Admin.create_author(author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author created successfully.")
        |> redirect(to: Routes.author_path(conn, :show, author))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    author = Admin.get_author!(id)
    render(conn, "show.html", author: author)
  end

  def edit(conn, %{"id" => id}) do
    author = Admin.get_author!(id)
    changeset = Admin.change_author(author)
    render(conn, "edit.html", author: author, changeset: changeset)
  end

  def update(conn, %{"id" => id, "author" => author_params}) do
    author = Admin.get_author!(id)

    case Admin.update_author(author, author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author updated successfully.")
        |> redirect(to: Routes.author_path(conn, :show, author))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", author: author, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    author = Admin.get_author!(id)
    item_name = BooklistWeb.AuthorView.to_s(author)
    {:ok, _author} = Admin.delete_author(author)

    conn
    |> put_flash(:info, item_name <> " deleted.")
    |> redirect(to: Routes.author_path(conn, :index))
  end
end
