defmodule BooklistWeb.LibraryController do
  use BooklistWeb, :controller

  alias Booklist.Admin
  alias Booklist.Admin.Library

  def index(conn, _params) do
    libraries = Admin.list_libraries()
    render(conn, "index.html", libraries: libraries)
  end

  def new(conn, _params) do
    changeset = Admin.change_library(%Library{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"library" => library_params}) do
    case Admin.create_library(library_params) do
      {:ok, library} ->
        conn
        |> put_flash(:info, "Library created successfully.")
        |> redirect(to: Routes.library_path(conn, :show, library))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    library = Admin.get_library!(id)
    render(conn, "show.html", library: library)
  end

  def edit(conn, %{"id" => id}) do
    library = Admin.get_library!(id)
    changeset = Admin.change_library(library)
    render(conn, "edit.html", library: library, changeset: changeset)
  end

  def update(conn, %{"id" => id, "library" => library_params}) do
    library = Admin.get_library!(id)

    case Admin.update_library(library, library_params) do
      {:ok, library} ->
        conn
        |> put_flash(:info, "Library updated successfully.")
        |> redirect(to: Routes.library_path(conn, :show, library))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", library: library, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    library = Admin.get_library!(id)
    item_name = BooklistWeb.LibraryView.to_s(library)
    {:ok, _library} = Admin.delete_library(library)

    conn
    |> put_flash(:info, item_name <> " deleted.")
    |> redirect(to: Routes.library_path(conn, :index))
  end
end
