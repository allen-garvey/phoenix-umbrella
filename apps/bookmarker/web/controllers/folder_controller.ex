defmodule Bookmarker.FolderController do
  use Bookmarker.Web, :controller

  alias Bookmarker.Folder

  def index(conn, _params) do
    folders = Folder.with_bookmarks_count_query |> Repo.all
    
    render(conn, "index.html", folders: folders)
  end

  def new(conn, _params) do
    changeset = Folder.changeset(%Folder{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"folder" => folder_params}) do
    changeset = Folder.changeset(%Folder{}, folder_params)

    case Repo.insert(changeset) do
      {:ok, _folder} ->
        conn
        |> put_flash(:info, "Folder created successfully.")
        |> redirect(to: folder_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    folder = Repo.get!(Folder, id) |> Repo.preload([bookmarks: from(bookmark in Bookmarker.Bookmark, order_by: [desc: :id])])
    render(conn, "show.html", folder: folder)
  end

  def edit(conn, %{"id" => id}) do
    folder = Repo.get!(Folder, id)
    changeset = Folder.changeset(folder)
    render(conn, "edit.html", folder: folder, changeset: changeset)
  end

  def update(conn, %{"id" => id, "folder" => folder_params}) do
    folder = Repo.get!(Folder, id)
    changeset = Folder.changeset(folder, folder_params)

    case Repo.update(changeset) do
      {:ok, folder} ->
        conn
        |> put_flash(:info, "Folder updated successfully.")
        |> redirect(to: folder_path(conn, :show, folder))
      {:error, changeset} ->
        render(conn, "edit.html", folder: folder, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    folder = Repo.get!(Folder, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(folder)

    conn
    |> put_flash(:info, "Folder deleted successfully.")
    |> redirect(to: folder_path(conn, :index))
  end
end
