defmodule PhotogWeb.TagController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.Tag
  alias Common.NumberHelpers

  action_fallback(PhotogWeb.FallbackController)

  def index(conn, %{"excerpt" => "true"}) do
    tags = Api.list_tags_excerpt()
    render(conn, "index.json", tags: tags)
  end

  def index(conn, %{"is_favorite" => is_favorite_param}) do
    tags = Api.list_tags_by_favorite(is_favorite_param === "true")
    render(conn, "index_with_cover_image.json", tags: tags)
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

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("ok.json", message: "ok")
  end

  def albums_for(conn, %{"id" => id, "excerpt" => "true"}) do
    albums = Api.get_albums_for_tag(id)

    conn
    |> put_view(PhotogWeb.AlbumView)
    |> render("index_excerpt.json", albums: albums)
  end

  def albums_for(conn, %{"id" => id, "limit" => limit, "offset" => offset}) do
    albums =
      Api.get_albums_for_tag(
        id,
        NumberHelpers.string_to_integer_with_min(limit, 1, 1),
        NumberHelpers.string_to_integer_with_min(offset, 0)
      )

    conn
    |> put_view(PhotogWeb.AlbumView)
    |> render("index_for_tags.json", albums: albums)
  end

  def images_for(conn, %{"id" => id, "excerpt" => "true"}) do
    images = Api.get_images_for_tag(id, :excerpt)

    conn
    |> put_view(PhotogWeb.ImageView)
    |> render("index_slideshow.json", images: images)
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
    with {1, _} <- Api.delete_tag_by_id(id) do
      conn
      |> put_view(CommonWeb.ApiGenericView)
      |> render("ok.json", message: "Tag deleted.")
    end
  end

  @doc """
  Removes albums from an tag
  """
  def remove_albums_from_tag(conn, %{"id" => tag_id, "album_ids" => album_ids})
      when is_list(album_ids) do
    Api.delete_album_tags(tag_id, album_ids)

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("ok.json", message: "Albums removed from tag")
  end
end
