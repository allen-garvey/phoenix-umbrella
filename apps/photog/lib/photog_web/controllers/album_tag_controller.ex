defmodule PhotogWeb.AlbumTagController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.AlbumTag

  action_fallback PhotogWeb.FallbackController

  def index(conn, _params) do
    album_tags = Api.list_album_tags()
    render(conn, "index.json", album_tags: album_tags)
  end

  @doc """
  Batch add tags_ids to each given album_id in album_ids
  """
  def create(conn, %{"album_ids" => album_ids, "tag_ids" => tag_ids}) do
    {total_added, total_errors} =
      Enum.reduce(album_ids, {[], []}, fn album_id, {total_added, total_errors} ->
        {tags_added, errors} =
          Enum.reduce(tag_ids, {[], []}, fn tag_id, {tags_added, errors} ->
            album_tag_params = %{"album_id" => album_id, "tag_id" => tag_id}
            case Api.create_album_tag(album_tag_params) do
              {:ok, %AlbumTag{} = _album_tag} -> { [album_tag_params | tags_added], errors }
              {:error, _changeset}                  -> { tags_added, [ album_tag_params | errors] }

            end
          end)
        {tags_added ++ total_added, errors ++ total_errors}
      end)

    conn
    |> put_view(PhotogWeb.GenericView)
    |> (&(
      if Enum.empty?(total_errors) do
        render(&1, "ok.json", message: total_added)
      else
        render(&1, "mixed_response.json", message: total_added, error: total_errors)
      end
    )).()
  end

  def create(conn, %{"album_tag" => album_tag_params}) do
    with {:ok, %AlbumTag{} = album_tag} <- Api.create_album_tag(album_tag_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", album_tag_path(conn, :show, album_tag))
      |> render("show.json", album_tag: album_tag)
    end
  end

  def show(conn, %{"id" => id}) do
    album_tag = Api.get_album_tag!(id)
    render(conn, "show.json", album_tag: album_tag)
  end

  def update(conn, %{"id" => id, "album_tag" => album_tag_params}) do
    album_tag = Api.get_album_tag!(id)

    with {:ok, %AlbumTag{} = album_tag} <- Api.update_album_tag(album_tag, album_tag_params) do
      render(conn, "show.json", album_tag: album_tag)
    end
  end

  def delete(conn, %{"id" => id}) do
    album_tag = Api.get_album_tag!(id)

    with {:ok, %AlbumTag{}} <- Api.delete_album_tag(album_tag) do
      send_resp(conn, :no_content, "")
    end
  end
end
