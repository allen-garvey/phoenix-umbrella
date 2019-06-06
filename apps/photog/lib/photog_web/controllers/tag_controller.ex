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
    results = Api.list_tags_with_cover_image()
    render(conn, "index_with_cover_image.json", results: results)
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
      send_resp(conn, :no_content, "")
    end
  end
end
