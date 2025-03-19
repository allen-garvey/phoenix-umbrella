defmodule PhotogWeb.PersonController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.Person
  alias Photog.Api.PersonImage
  alias Common.NumberHelpers

  action_fallback(PhotogWeb.FallbackController)

  def index(conn, %{"excerpt" => "true"}) do
    persons = Api.list_persons_excerpt()
    render(conn, "index_excerpt.json", persons: persons)
  end

  def index(conn, _params) do
    persons = Api.list_persons()
    render(conn, "index.json", persons: persons)
  end

  def create(conn, %{"person" => person_params, "image_ids" => image_ids}) do
    with {:ok, %Person{} = person} <- Api.create_person(person_params) do
      {_, _} = add_images_to_person(person.id, image_ids)

      conn
      |> put_status(:created)
      |> render("show_excerpt_mini.json", person: person)
    end
  end

  def create(conn, %{"person" => person_params}) do
    with {:ok, %Person{} = person} <- Api.create_person(person_params) do
      conn
      |> put_status(:created)
      |> render("show_excerpt_mini.json", person: person)
    end
  end

  @doc """
  Adds images to an person
  returns {image_ids_added, errors}
  """
  def add_images_to_person(person_id, image_ids) do
    Enum.reduce(image_ids, {[], []}, fn image_id, {images_added, errors} ->
      case Api.create_person_image(%{"person_id" => person_id, "image_id" => image_id}) do
        {:ok, %PersonImage{} = person_image} -> {[person_image.image_id | images_added], errors}
        {:error, _changeset} -> {images_added, [image_id | errors]}
      end
    end)
  end

  @doc """
  Removes images from an person
  """
  def remove_images_from_person(conn, %{"id" => person_id, "image_ids" => image_ids})
      when is_list(image_ids) do
    Api.delete_person_images(person_id, image_ids)

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("ok.json", message: "Images removed from person")
  end

  def images_for(conn, %{"id" => id, "excerpt" => "true"}) do
    images = Api.get_images_for_person(id)

    conn
    |> put_view(PhotogWeb.ImageView)
    |> render("index_thumbnails.json", images: images)
  end

  def images_for(conn, %{"id" => id, "limit" => limit, "offset" => offset}) do
    images =
      Api.get_images_for_person(
        id,
        NumberHelpers.string_to_integer_with_min(limit, 1, 1),
        NumberHelpers.string_to_integer_with_min(offset, 0)
      )

    conn
    |> put_view(PhotogWeb.ImageView)
    |> render("index_thumbnail_list.json", images: images)
  end

  def show(conn, %{"id" => id}) do
    person = Api.get_person!(id)
    render(conn, "show.json", person: person)
  end

  def update(conn, %{"id" => id, "person" => person_params}) do
    person = Api.get_person!(id)

    with {:ok, %Person{} = person} <- Api.update_person(person, person_params) do
      render(conn, "show_excerpt_mini.json", person: person)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {1, _} <- Api.delete_person_by_id(id) do
      conn
      |> put_view(CommonWeb.ApiGenericView)
      |> render("ok.json", message: "Person deleted.")
    end
  end
end
