defmodule Bookmarker.BookmarkController do
  use Bookmarker.Web, :controller

  alias Bookmarker.Bookmark

  def index(conn, _params) do
    bookmarks = Repo.all(from Bookmark, order_by: [desc: :id])
    render(conn, "index.html", bookmarks: bookmarks)
  end

  def new(conn, _params) do
    changeset = Bookmark.changeset(%Bookmark{})
    folders = Bookmarker.Folder.form_list(Repo)
    render(conn, "new.html", changeset: changeset, folders: folders)
  end

  def create(conn, %{"bookmark" => bookmark_params, "form_submit_type" => submit_type}) do
    changeset = Bookmark.changeset(%Bookmark{}, bookmark_params)

    case Repo.insert(changeset) do
      {:ok, bookmark} ->
        if submit_type == "add_another" do
          changeset = Bookmark.changeset(%Bookmark{folder_id: bookmark.folder_id})
          folders = Bookmarker.Folder.form_list(Repo)
          render(conn, "new.html", changeset: changeset, folders: folders, flash: Bookmark.to_s(bookmark) <> " saved.")
        else
          conn
            |> put_flash(:info, "Bookmark created successfully.")
            |> redirect(to: bookmark_path(conn, :index))
        end
      {:error, changeset} ->
        folders = Bookmarker.Folder.form_list(Repo)
        render(conn, "new.html", changeset: changeset, folders: folders)
    end
  end

  def show(conn, %{"id" => id}) do
    bookmark = Repo.get!(Bookmark, id) |> Repo.preload([:folder, :tags])
    render(conn, "show.html", enable_js: true, csrf_token: get_csrf_token(), bookmark: bookmark)
  end

  def edit(conn, %{"id" => id}) do
    bookmark = Repo.get!(Bookmark, id)
    changeset = Bookmark.changeset(bookmark)
    folders = Bookmarker.Folder.form_list(Repo)
    render(conn, "edit.html", bookmark: bookmark, changeset: changeset, folders: folders)
  end

  def update(conn, %{"id" => id, "bookmark" => bookmark_params}) do
    bookmark = Repo.get!(Bookmark, id)
    changeset = Bookmark.changeset(bookmark, bookmark_params)

    case Repo.update(changeset) do
      {:ok, bookmark} ->
        conn
        |> put_flash(:info, "Bookmark updated successfully.")
        |> redirect(to: bookmark_path(conn, :show, bookmark))
      {:error, changeset} ->
        folders = Bookmarker.Folder.form_list(Repo)
        render(conn, "edit.html", bookmark: bookmark, changeset: changeset, folders: folders)
    end
  end

  def delete(conn, %{"id" => id}) do
    bookmark = Repo.get!(Bookmark, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(bookmark)

    conn
    |> put_flash(:info, "Bookmark deleted successfully.")
    |> redirect(to: bookmark_path(conn, :index))
  end

end
