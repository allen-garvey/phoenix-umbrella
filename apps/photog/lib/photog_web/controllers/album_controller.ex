defmodule PhotogWeb.AlbumController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.Album
  alias Photog.Api.AlbumImage
  alias Photog.Api.AlbumTag

  action_fallback PhotogWeb.FallbackController

  # used for forms when we only need name and id
  def index(conn, %{"excerpt" => "true"}) do
    albums = Api.list_albums_excerpt()
    render(conn, "index_excerpt.json", albums: albums)
  end

  def index(conn, %{"favorites" => is_favorite_param, "limit" => limit, "offset" => offset}) do
    albums = Api.list_album_favorites(is_favorite_param == "true", String.to_integer(limit), String.to_integer(offset))
    render(conn, "index.json", albums: albums)
  end

  def index(conn, %{"limit" => limit, "offset" => offset}) do
    albums = Api.list_albums(String.to_integer(limit), String.to_integer(offset))
    render(conn, "index.json", albums: albums)
  end

  def index(conn, _params) do
    albums = Api.list_albums()
    render(conn, "index.json", albums: albums)
  end

  def create(conn, %{"album" => album_params, "image_ids" => image_ids, "tag_ids" => tag_ids}) do
    create_album(conn, album_params, fn album -> 
      {_, _} = add_images_to_album(album.id, image_ids)
      {_, _} = add_tags_to_album(album.id, tag_ids)
    end)
  end

  def create(conn, %{"album" => album_params, "tag_ids" => tag_ids}) do
    create_album(conn, album_params, fn album -> 
      {_, _} = add_tags_to_album(album.id, tag_ids)
    end)
  end

  def create(conn, %{"album" => album_params, "image_ids" => image_ids}) do
    create_album(conn, album_params, fn album -> 
      {_, _} = add_images_to_album(album.id, image_ids)
    end)
  end

  def create(conn, %{"album" => album_params}) do
    create_album(conn, album_params, fn _album -> true end)
  end

  def create_album(conn, album_params, created_callback) do
    with {:ok, %Album{} = album} <- Api.create_album(album_params) do
      created_callback.(album)
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
  Adds tags to an album
  returns {tag_ids_added, errors}
  """
  def add_tags_to_album(album_id, tag_ids) do
    Enum.reduce(tag_ids, {[], []}, fn tag_id, {tags_added, errors} ->
      case Api.create_album_tag(%{"album_id" => album_id, "tag_id" => tag_id}) do
        {:ok, %AlbumTag{} = album_tag} -> { [album_tag.tag_id | tags_added], errors }
        {:error, _changeset}                -> { tags_added, [ tag_id | errors] }
      end
    end)
  end

  @doc """
  Removes images from an album
  """
  def remove_images_from_album(conn, %{"id" => album_id, "image_ids" => image_ids}) when is_list(image_ids) do
    Api.delete_album_images(album_id, image_ids)

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("ok.json", message: "Images removed from album")
  end

  @doc """
  Reorders images in album
  """
  def reorder_images(conn, %{"id" => id, "image_ids" => image_ids}) when is_list(image_ids) do
    view = conn |> put_view(CommonWeb.ApiGenericView)
    
    case Api.reorder_images_for_album(id, image_ids) do
      {:ok, _} -> view |> render("ok.json", message: "ok")
      {:error, _} -> view |> put_status(:bad_request) |> render("error.json", message: "Could not reorder images for #{id}")
    end
  end

  @doc """
  Replaces an album's tags with given list of tags
  """
  def replace_tags(conn,  %{"id" => id, "tag_ids" => tag_ids}) when is_list(tag_ids) do
    view = conn |> put_view(CommonWeb.ApiGenericView)

    case Api.replace_tags_for_album(id, tag_ids) do
      {:ok, _} -> view |> render("ok.json", message: "ok")
      {:error, _} -> view |> put_status(:bad_request) |> render("error.json", message: "Error saving tags for album #{id}")
    end
  end

  @doc """
  Return count of all albums
  """
  def count(conn, %{"favorites" => is_favorite_param}) do
    count = Api.albums_favorite_count!(is_favorite_param == "true")
    
    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("data.json", data: count)
  end

  def count(conn, _params) do
    count = Api.albums_count!
    
    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("data.json", data: count)
  end

  def images_for(conn, %{"id" => id, "excerpt" => "true"}) do
    images = Api.get_images_for_album(id, :excerpt)
    
    conn
    |> put_view(PhotogWeb.ImageView)
    |> render("index_slideshow.json", images: images)
  end

  def images_for(conn, %{"id" => id, "limit" => limit, "offset" => offset}) do
    images = Api.get_images_for_album(id, String.to_integer(limit), String.to_integer(offset))
    
    conn
    |> put_view(PhotogWeb.ImageView)
    |> render("index_thumbnail_list.json", images: images)
  end

  @doc """
  Returns all albums taken in given year
  """
  def albums_for_year(conn, %{"year" => year, "limit" => limit, "offset" => offset}) do
    albums = Api.list_albums_for_year(String.to_integer(year), String.to_integer(limit), String.to_integer(offset))
    render(conn, "index.json", albums: albums)
  end

  @doc """
  Return count of all albums taken in given year
  """
  def albums_for_year_count(conn, %{"year" => year}) do
    count = String.to_integer(year) |> Api.albums_count_for_year!
    
    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("data.json", data: count)
  end

  def show(conn, %{"id" => id}) do
    album = Api.get_album!(id)
    persons = Api.get_persons_for_album(id)
    
    render(conn, "show.json", album: album, persons: persons)
  end

  def update(conn, %{"id" => id, "album" => album_params}) do
    album = Api.get_album!(id)

    with {:ok, %Album{} = album} <- Api.update_album(album, album_params) do
      render(conn, "show_excerpt_mini.json", album: album)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {1, _} <- Api.delete_album_by_id(id) do
      conn
      |> put_view(CommonWeb.ApiGenericView)
      |> render("ok.json", message: "Album deleted.")
    end
  end
end
