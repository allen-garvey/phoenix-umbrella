defmodule StartpageWeb.FolderController do
  use StartpageWeb, :controller

  alias Startpage.Admin
  alias Startpage.Admin.Folder

  def index(conn, _params) do
    folders = Admin.list_folders_in_order()
    render(conn, "index.html", folders: folders)
  end

  def new(conn, _params) do
    changeset = Admin.change_folder(%Folder{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"folder" => folder_params}) do
    case Admin.create_folder(folder_params) do
      {:ok, _folder} ->
        conn
        |> put_flash(:info, "Folder created successfully.")
        |> redirect(to: Routes.folder_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    folder = Admin.get_folder!(id)
    render(conn, "show.html", folder: folder)
  end

  def edit(conn, %{"id" => id}) do
    folder = Admin.get_folder!(id)
    changeset = Admin.change_folder(folder)
    render(conn, "edit.html", folder: folder, changeset: changeset)
  end

  def update(conn, %{"id" => id, "folder" => folder_params}) do
    folder = Admin.get_folder!(id)

    case Admin.update_folder(folder, folder_params) do
      {:ok, _folder} ->
        conn
        |> put_flash(:info, "Folder updated successfully.")
        |> redirect(to: Routes.folder_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", folder: folder, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    folder = Admin.get_folder!(id)
    {:ok, _folder} = Admin.delete_folder(folder)

    conn
    |> put_flash(:info, "Folder deleted successfully.")
    |> redirect(to: Routes.folder_path(conn, :index))
  end
end
