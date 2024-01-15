defmodule PhotogWeb.AlbumImageController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.AlbumImage

  action_fallback PhotogWeb.FallbackController

  def index(conn, _params) do
    album_images = Api.list_album_images()
    render(conn, "index.json", album_images: album_images)
  end

  @doc """
  Batch add album_ids to each given image_id in image_ids
  """
  def create(conn, %{"image_ids" => image_ids, "album_ids" => album_ids}) do
    {total_added, total_errors} =
      Enum.reduce(image_ids, {[], []}, fn image_id, {total_added, total_errors} ->
        {albums_added, errors} =
          Enum.reduce(album_ids, {[], []}, fn album_id, {albums_added, errors} ->
            album_image_params = %{"image_id" => image_id, "album_id" => album_id}
            case Api.create_album_image(album_image_params) do
              {:ok, %AlbumImage{} = _album_image} -> { [album_image_params | albums_added], errors }
              {:error, _changeset}                  -> { albums_added, [ album_image_params | errors] }

            end
          end)
        {albums_added ++ total_added, errors ++ total_errors}
      end)

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> (&(
      if Enum.empty?(total_errors) do
        render(&1, "ok.json", message: total_added)
      else
        render(&1, "mixed_response.json", message: total_added, error: total_errors)
      end
    )).()
  end

  def create(conn, %{"album_image" => album_image_params}) do
    with {:ok, %AlbumImage{} = album_image} <- Api.create_album_image(album_image_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", album_image_path(conn, :show, album_image))
      |> render("show.json", album_image: album_image)
    end
  end

  def show(conn, %{"id" => id}) do
    album_image = Api.get_album_image!(id)
    render(conn, "show.json", album_image: album_image)
  end

  def update(conn, %{"id" => id, "album_image" => album_image_params}) do
    album_image = Api.get_album_image!(id)

    with {:ok, %AlbumImage{} = album_image} <- Api.update_album_image(album_image, album_image_params) do
      render(conn, "show.json", album_image: album_image)
    end
  end

  def delete(conn, %{"id" => id}) do
    album_image = Api.get_album_image!(id)
    with {:ok, %AlbumImage{}} <- Api.delete_album_image(album_image) do
      send_resp(conn, :no_content, "")
    end
  end
end
