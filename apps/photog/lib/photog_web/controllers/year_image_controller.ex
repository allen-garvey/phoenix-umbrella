defmodule PhotogWeb.YearImageController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.YearImage

  action_fallback PhotogWeb.FallbackController

  def create(conn, %{"year_image" => year_image_params}) do
    with {:ok, %YearImage{} = _year_image} <- Api.create_year_image(year_image_params) do
      conn
      |> put_status(:created)
      |> put_view(CommonWeb.ApiGenericView)
      |> render("ok.json", message: "ok")
    end
  end

  def delete(conn, %{"year" => year, "image_id" => image_id}) do
    Api.delete_year_image(year, image_id)
    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("ok.json", message: "ok")
  end
end
