defmodule PhotogWeb.YearImageController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.YearImage

  action_fallback PhotogWeb.FallbackController

  def index(conn, _params) do
    year_images = Api.list_year_images()
    render(conn, "index.json", year_images: year_images)
  end

  def create(conn, %{"year_image" => year_image_params}) do
    with {:ok, %YearImage{} = year_image} <- Api.create_year_image(year_image_params) do
      conn
      |> put_status(:created)
      |> render("show.json", year_image: year_image)
    end
  end

  def show(conn, %{"id" => id}) do
    year_image = Api.get_year_image!(id)
    render(conn, "show.json", year_image: year_image)
  end

  def update(conn, %{"id" => id, "year_image" => year_image_params}) do
    year_image = Api.get_year_image!(id)

    with {:ok, %YearImage{} = year_image} <- Api.update_year_image(year_image, year_image_params) do
      render(conn, "show.json", year_image: year_image)
    end
  end

  def delete(conn, %{"year" => year, "image_id" => image_id}) do
    Api.delete_year_image(year, image_id)
    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("ok.json", message: "ok")
  end
end
