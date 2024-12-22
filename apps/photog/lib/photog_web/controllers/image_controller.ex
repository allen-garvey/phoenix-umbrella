defmodule PhotogWeb.ImageController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.Image
  alias Photog.Api.AlbumImage
  alias Photog.Api.PersonImage
  alias Common.NumberHelpers

  action_fallback(PhotogWeb.FallbackController)

  def index(conn, %{"favorites" => is_favorite_param, "limit" => limit, "offset" => offset}) do
    images =
      Api.list_image_favorites(
        is_favorite_param == "true",
        NumberHelpers.string_to_positive_integer(limit, 1),
        NumberHelpers.string_to_positive_integer(offset, 0)
      )

    render(conn, "index.json", images: images)
  end

  def index(conn, %{"in_album" => "false", "limit" => limit, "offset" => offset}) do
    images =
      Api.list_images_not_in_album(
        NumberHelpers.string_to_positive_integer(limit, 1),
        NumberHelpers.string_to_positive_integer(offset, 0)
      )

    render(conn, "index.json", images: images)
  end

  def index(conn, %{"amazon_photos_id" => "false", "limit" => limit, "offset" => offset}) do
    images =
      Api.list_images_with_no_amazon_photos_id(
        NumberHelpers.string_to_positive_integer(limit, 1),
        NumberHelpers.string_to_positive_integer(offset, 0)
      )

    render(conn, "index.json", images: images)
  end

  def index(conn, %{"limit" => limit, "offset" => offset}) do
    images =
      Api.list_images(
        NumberHelpers.string_to_positive_integer(limit, 1),
        NumberHelpers.string_to_positive_integer(offset, 0)
      )

    render(conn, "index.json", images: images)
  end

  def index(conn, _params) do
    images = Api.list_images()
    render(conn, "index.json", images: images)
  end

  def create(conn, %{"image" => image_params}) do
    with {:ok, %Image{} = image} <- Api.create_image(image_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", image_path(conn, :show, image))
      |> render("show.json", image: image)
    end
  end

  def show(conn, %{"id" => id}) do
    image = Api.get_image!(id, :full)
    render(conn, "show.json", image: image)
  end

  @doc """
  Returns all images taken in given year
  """
  def images_for_year(conn, %{"year" => year, "excerpt" => "true"}) do
    images = NumberHelpers.string_to_positive_integer(year, 1) |> Api.list_images_for_year()
    render(conn, "index_slideshow.json", images: images)
  end

  def images_for_year(conn, %{"year" => year, "limit" => limit, "offset" => offset}) do
    images =
      Api.list_images_for_year(
        NumberHelpers.string_to_positive_integer(year, 1),
        NumberHelpers.string_to_positive_integer(limit, 1),
        NumberHelpers.string_to_positive_integer(offset, 0)
      )

    render(conn, "index.json", images: images)
  end

  @doc """
  Return count of all images taken in given year
  """
  def images_for_year_count(conn, %{"year" => year}) do
    count = NumberHelpers.string_to_positive_integer(year, 1) |> Api.images_count_for_year!()

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("data.json", data: count)
  end

  @doc """
  Returns all images taken in given date
  """
  def images_for_date(conn, %{
        "month" => month,
        "day" => day
      }) do
    images =
      Api.list_images_for_date(
        NumberHelpers.string_to_positive_integer(month, 1),
        NumberHelpers.string_to_positive_integer(day, 1)
      )

    render(conn, "index.json", images: images)
  end

  def images_for_date(conn, %{
        "month" => month,
        "day" => day,
        "limit" => limit,
        "offset" => offset
      }) do
    images =
      Api.list_images_for_date(
        NumberHelpers.string_to_positive_integer(month, 1),
        NumberHelpers.string_to_positive_integer(day, 1),
        NumberHelpers.string_to_positive_integer(limit, 1),
        NumberHelpers.string_to_positive_integer(offset, 0)
      )

    render(conn, "index.json", images: images)
  end

  @doc """
  Return count of all images taken in given year
  """
  def images_for_date_count(conn, %{"month" => month, "day" => day}) do
    count =
      Api.images_count_for_date(
        NumberHelpers.string_to_positive_integer(month, 1),
        NumberHelpers.string_to_positive_integer(day, 1)
      )

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("data.json", data: count)
  end

  @doc """
  Return count of all images
  """
  def count(conn, %{"favorites" => is_favorite_param}) do
    count = Api.images_favorite_count!(is_favorite_param == "true")

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("data.json", data: count)
  end

  def count(conn, %{"in_album" => "false"}) do
    count = Api.images_not_in_album_count!()

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("data.json", data: count)
  end

  def count(conn, _params) do
    count = Api.images_count!()

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("data.json", data: count)
  end

  @doc """
  Search for image by master path
  """
  def search(conn, %{"q" => search_query}) do
    images = Api.list_images_for_query(search_query)

    render(conn, "index.json", images: images)
  end

  @doc """
  Gets the exif data from an image's master image
  """
  def exif_for(conn, %{"id" => id}) do
    image = Api.get_image_with_exif!(id)
    render(conn, "exif.json", exif: image.exif, image: image)
  end

  @doc """
  Adds albums to an image
  tags comma-delimited list of album ids
  """
  def add_albums(conn, %{"id" => image_id, "albums" => albums}) do
    {albums_added, errors} =
      String.split(albums, ",")
      |> Enum.reduce({[], []}, fn album_id, {albums_added, errors} ->
        case Api.create_album_image(%{"image_id" => image_id, "album_id" => album_id}) do
          {:ok, %AlbumImage{} = album_image} -> {[album_image.album_id | albums_added], errors}
          {:error, _changeset} -> {albums_added, [album_id | errors]}
        end
      end)

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> (&(if Enum.empty?(errors) do
            render(&1, "ok.json", message: albums_added)
          else
            render(&1, "mixed_response.json", message: albums_added, error: errors)
          end)).()
  end

  @doc """
  Adds persons to an image
  tags comma-delimited list of person ids
  """
  def add_persons(conn, %{"id" => image_id, "persons" => persons}) do
    {persons_added, errors} =
      String.split(persons, ",")
      |> Enum.reduce({[], []}, fn person_id, {persons_added, errors} ->
        case Api.create_person_image(%{"image_id" => image_id, "person_id" => person_id}) do
          {:ok, %PersonImage{} = person_image} ->
            {[person_image.person_id | persons_added], errors}

          {:error, _changeset} ->
            {persons_added, [person_id | errors]}
        end
      end)

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> (&(if Enum.empty?(errors) do
            render(&1, "ok.json", message: persons_added)
          else
            render(&1, "mixed_response.json", message: persons_added, error: errors)
          end)).()
  end

  def update(conn, %{"id" => id, "image" => image_params}) do
    image = Api.get_image!(id)

    with {:ok, %Image{} = image} <- Api.update_image(image, image_params) do
      conn
      |> put_view(CommonWeb.ApiGenericView)
      |> render("ok.json", message: "Image #{image.id} updated")
    end
  end

  def delete(conn, %{"id" => id}) do
    image = Api.get_image!(id)

    with {:ok, %Image{}} <- Api.delete_image(image) do
      send_resp(conn, :no_content, "")
    end
  end
end
