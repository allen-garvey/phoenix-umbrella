defmodule PhotogWeb.YearController do
    use PhotogWeb, :controller
  
    alias Photog.Api
    alias Photog.Api.Year
  
    action_fallback PhotogWeb.FallbackController
    
    def delete(conn, %{"year" => year}) do
        Api.delete_year(year)
        conn
        |> put_view(PhotogWeb.GenericView)
        |> render("ok.json", message: "ok")
    end

    def put(conn, %{"id" => _year, "description" => _description} = params) do
      with {:ok, %Year{} = year} <- Api.upsert_year(params) do
        conn
        |> put_status(:created)
        |> put_view(PhotogWeb.GenericView)
        |> render("data.json", data: Map.from_struct(year) |> Map.take([:year, :description]))
      end
    end
end
  