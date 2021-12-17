defmodule PhotogWeb.TagController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.Tag

  action_fallback PhotogWeb.FallbackController

  def index(conn, %{"sort" => "newest"}) do
    tags = Api.list_tags([desc: :id])
    render(conn, "index.json", tags: tags)
  end

  def index(conn, _params) do
    tags = Api.list_tags()
    render(conn, "index_with_cover_image.json", tags: tags)
  end

  def create(conn, %{"tag" => tag_params}) do
    with {:ok, %Tag{} = tag} <- Api.create_tag(tag_params) do
      conn
      |> put_status(:created)
      |> render("show_excerpt.json", tag: tag)
    end
  end

  @doc """
  Reorders albums in tag
  """
  def reorder_albums(conn, %{"id" => id, "album_ids" => album_ids}) when is_list(album_ids) do
    Api.reorder_albums_for_tag(id, album_ids)
    # have to send something back for js to register request succeeded
    send_resp(conn, 200, "{\"data\": \"ok\"}")
  end

  def albums_for(conn, %{"id" => id, "excerpt" => "true"}) do
    albums = Api.get_albums_for_tag(id)
    
    conn
    |> put_view(PhotogWeb.AlbumView)
    |> render("index_excerpt.json", albums: albums)
  end

  def albums_for(conn, %{"id" => id, "limit" => limit, "offset" => offset}) do
    albums = Api.get_albums_for_tag(id, String.to_integer(limit), String.to_integer(offset))
    
    conn
    |> put_view(PhotogWeb.AlbumView)
    |> render("index.json", albums: albums)
  end

  def show(conn, %{"id" => id}) do
    tag = Api.get_tag!(id)
    render(conn, "show.json", tag: tag)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    tag = Api.get_tag!(id)

    with {:ok, %Tag{} = tag} <- Api.update_tag(tag, tag_params) do
      render(conn, "show_excerpt.json", tag: tag)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Api.get_tag!(id)

    with {:ok, %Tag{}} <- Api.delete_tag(tag) do
      send_resp(conn, 200, "{\"data\": \"ok\"}")
    end
  end
end
