defmodule PhotogWeb.PersonImageController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.PersonImage

  action_fallback PhotogWeb.FallbackController

  def index(conn, _params) do
    person_images = Api.list_person_images()
    render(conn, "index.json", person_images: person_images)
  end

  @doc """
  Batch add person_ids to each given image_id in image_ids
  """
  def create(conn, %{"image_ids" => image_ids, "person_ids" => person_ids}) do
    {total_added, total_errors} =
      Enum.reduce(image_ids, {[], []}, fn image_id, {total_added, total_errors} ->
        {persons_added, errors} =
          Enum.reduce(person_ids, {[], []}, fn person_id, {persons_added, errors} ->
            person_image_params = %{"image_id" => image_id, "person_id" => person_id}
            case Api.create_person_image(person_image_params) do
              {:ok, %PersonImage{} = _person_image} -> { [person_image_params | persons_added], errors }
              {:error, _changeset}                  -> { persons_added, [ person_image_params | errors] }

            end
          end)
        {persons_added ++ total_added, errors ++ total_errors}
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

  def create(conn, %{"person_image" => person_image_params}) do
    with {:ok, %PersonImage{} = person_image} <- Api.create_person_image(person_image_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", person_image_path(conn, :show, person_image))
      |> render("show.json", person_image: person_image)
    end
  end

  def show(conn, %{"id" => id}) do
    person_image = Api.get_person_image!(id)
    render(conn, "show.json", person_image: person_image)
  end

  def update(conn, %{"id" => id, "person_image" => person_image_params}) do
    person_image = Api.get_person_image!(id)

    with {:ok, %PersonImage{} = person_image} <- Api.update_person_image(person_image, person_image_params) do
      render(conn, "show.json", person_image: person_image)
    end
  end

  def delete(conn, %{"id" => id}) do
    person_image = Api.get_person_image!(id)
    with {:ok, %PersonImage{}} <- Api.delete_person_image(person_image) do
      send_resp(conn, :no_content, "")
    end
  end
end
