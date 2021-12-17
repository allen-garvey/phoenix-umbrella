defmodule PhotogWeb.AlbumController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.Album
  alias Photog.Api.AlbumImage

  action_fallback PhotogWeb.FallbackController

  def index(conn, %{"excerpt" => "true"}) do
    albums = Api.list_albums_excerpt()
    render(conn, "index_excerpt.json", albums: albums)
  end

  def index(conn, %{"limit" => limit, "offset" => offset}) do
    albums = Api.list_albums(String.to_integer(limit), String.to_integer(offset))
    render(conn, "index.json", albums: albums)
  end

  def index(conn, _params) do
    albums = Api.list_albums()
    render(conn, "index.json", albums: albums)
  end

  def create(conn, %{"album" => album_params, "image_ids" => image_ids}) do
    with {:ok, %Album{} = album} <- Api.create_album(album_params) do
      {_, _} = add_images_to_album(album.id, image_ids)
      conn
      |> put_status(:created)
      |> render("show_excerpt_mini.json", album: album)
    end
  end

  def create(conn, %{"album" => album_params}) do
    with {:ok, %Album{} = album} <- Api.create_album(album_params) do
      conn
      |> put_status(:created)
      |> render("show_excerpt_mini.json", album: album)
    end
  end

  @doc """
  Adds images to an album
  returns {image_ids_added, errors}
  """
  def add_images_to_album(album_id, image_ids) do
    Enum.reduce(image_ids, {[], []}, fn image_id, {images_added, errors} ->
      case Api.create_album_image(%{"album_id" => album_id, "image_id" => image_id}) do
        {:ok, %AlbumImage{} = album_image} -> { [album_image.image_id | images_added], errors }
        {:error, _changeset}                -> { images_added, [ image_id | errors] }
      end
    end)
  end

  @doc """
  Reorders images in album
  """
  def reorder_images(conn, %{"id" => id, "image_ids" => image_ids}) when is_list(image_ids) do
    case Api.reorder_images_for_album(id, image_ids) do
      {:ok, _} -> send_resp(conn, 200, "{\"data\": \"ok\"}")
      {:error, _} -> send_resp(conn, 400, "{\"error\": \"Could not reorder images for #{id}\"}")
    end
  end

  @doc """
  Replaces an album's tags with given list of tags
  """
  def replace_tags(conn,  %{"id" => id, "tag_ids" => tag_ids}) when is_list(tag_ids) do
    case Api.replace_tags_for_album(id, tag_ids) do
      {:ok, _} -> send_resp(conn, 200, "{\"data\": \"ok\"}")
      {:error, _} -> send_resp(conn, 400, "{\"error\": \"Error saving tags for album #{id}\"}")
    end
  end

  def images_for(conn, %{"id" => id, "excerpt" => "true"}) do
    images = Api.get_images_for_album(id)
    
    conn
    |> put_view(PhotogWeb.ImageView)
    |> render("index_thumbnails.json", images: images)
  end

  def images_for(conn, %{"id" => id, "limit" => limit, "offset" => offset}) do
    images = Api.get_images_for_album(id, String.to_integer(limit), String.to_integer(offset))
    
    conn
    |> put_view(PhotogWeb.ImageView)
    |> render("index.json", images: images)
  end

  def show(conn, %{"id" => id}) do
    album = Api.get_album!(id)
    render(conn, "show.json", album: album)
  end

  def update(conn, %{"id" => id, "album" => album_params}) do
    album = Api.get_album!(id)

    with {:ok, %Album{} = album} <- Api.update_album(album, album_params) do
      render(conn, "show_excerpt_mini.json", album: album)
    end
  end

  def delete(conn, %{"id" => id}) do
    album = Api.get_album!(id)
    with {:ok, %Album{}} <- Api.delete_album(album) do
      send_resp(conn, 200, "{\"data\": \"ok\"}")
    end
  end
end
