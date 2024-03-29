defmodule Bookmarker.ApiBookmarkTagController do
  use Bookmarker.Web, :controller

  alias Bookmarker.BookmarkTag

  @doc """
  Creates a bookmark tag for given bookmark_id and tag_id
  returns 400 if necessary params are missing
  """
  def create_bookmark_tag(conn, %{"bookmark_id" => bookmark_id, "tag_id" => tag_id}) do
    bookmark_tag_params = %{"bookmark_id" => bookmark_id, "tag_id" => tag_id}
    changeset = BookmarkTag.changeset(%BookmarkTag{}, bookmark_tag_params)

    case Repo.insert(changeset) do
      {:ok, bookmark_tag} ->
        bookmark_tag = Repo.preload(bookmark_tag, [:tag])
        render(conn, "show.json", bookmark_tag: bookmark_tag)
      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render("create_error.json", errors: changeset.errors)
    end
  end

  def create_bookmark_tag(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", error: %{title: "Invalid params", detail: "Missing bookmark_id or tag_id"})
  end

  @doc """
  Deletes a bookmark_tag for given bookmark_tag_id or
  Deletes a bookmark_tag for given bookmark_id and tag_id
  Return 400 if necessary params missing
  """
  def delete_bookmark_tag(conn, %{"id" => id}) do
    bookmark_tag = Repo.get!(BookmarkTag, id) |> Repo.preload([:tag])

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(bookmark_tag)
    render(conn, "show.json", bookmark_tag: bookmark_tag)
  end

  def delete_bookmark_tag(conn, %{"bookmark_id" => bookmark_id, "tag_id" => tag_id}) do
    bookmark_tag = Repo.get_by!(BookmarkTag, bookmark_id: bookmark_id, tag_id: tag_id) |> Repo.preload([:tag])

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(bookmark_tag)
    render(conn, "show.json", bookmark_tag: bookmark_tag)
  end

  def delete_bookmark_tag(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", error: %{title: "Invalid params", detail: "No id or (bookmark_id, tag_id) composite given for bookmark_tag to delete"})
  end

end
