defmodule Bookmarker.BookmarkTagController do
  use Bookmarker.Web, :controller

  alias Bookmarker.BookmarkTag

  def index(conn, _params) do
    bookmarks_tags = Repo.all(from BookmarkTag, order_by: [desc: :id]) |> Repo.preload([:bookmark, :tag])
    render(conn, "index.html", bookmarks_tags: bookmarks_tags)
  end

  def new(conn, _params) do
    changeset = BookmarkTag.changeset(%BookmarkTag{})
    bookmarks = Bookmarker.Bookmark.form_list(Repo)
    tags = Bookmarker.Tag.form_list(Repo)
    render(conn, "new.html", changeset: changeset, tags: tags, bookmarks: bookmarks)
  end

  def create(conn, %{"bookmark_tag" => bookmark_tag_params}) do
    changeset = BookmarkTag.changeset(%BookmarkTag{}, bookmark_tag_params)

    case Repo.insert(changeset) do
      {:ok, _bookmark_tag} ->
        conn
        |> put_flash(:info, "Bookmark tag created successfully.")
        |> redirect(to: bookmark_tag_path(conn, :index))
      {:error, changeset} ->
        bookmarks = Bookmarker.Bookmark.form_list(Repo)
        tags = Bookmarker.Tag.form_list(Repo)
        render(conn, "new.html", changeset: changeset, bookmarks: bookmarks, tags: tags)
    end
  end

  def show(conn, %{"id" => id}) do
    bookmark_tag = Repo.get!(BookmarkTag, id) |> Repo.preload([:bookmark, :tag])
    render(conn, "show.html", bookmark_tag: bookmark_tag)
  end

  def edit(conn, %{"id" => id}) do
    bookmark_tag = Repo.get!(BookmarkTag, id)
    changeset = BookmarkTag.changeset(bookmark_tag)
    bookmarks = Bookmarker.Bookmark.form_list(Repo)
    tags = Bookmarker.Tag.form_list(Repo)
    render(conn, "edit.html", bookmark_tag: bookmark_tag, changeset: changeset, bookmarks: bookmarks, tags: tags)
  end

  def update(conn, %{"id" => id, "bookmark_tag" => bookmark_tag_params}) do
    bookmark_tag = Repo.get!(BookmarkTag, id)
    changeset = BookmarkTag.changeset(bookmark_tag, bookmark_tag_params)

    case Repo.update(changeset) do
      {:ok, bookmark_tag} ->
        conn
        |> put_flash(:info, "Bookmark tag updated successfully.")
        |> redirect(to: bookmark_tag_path(conn, :show, bookmark_tag))
      {:error, changeset} ->
        bookmarks = Bookmarker.Bookmark.form_list(Repo)
        tags = Bookmarker.Tag.form_list(Repo)
        render(conn, "edit.html", bookmark_tag: bookmark_tag, changeset: changeset, bookmarks: bookmarks, tags: tags)
    end
  end

  def delete(conn, %{"id" => id}) do
    bookmark_tag = Repo.get!(BookmarkTag, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(bookmark_tag)

    conn
    |> put_flash(:info, "Bookmark tag deleted successfully.")
    |> redirect(to: bookmark_tag_path(conn, :index))
  end
end
