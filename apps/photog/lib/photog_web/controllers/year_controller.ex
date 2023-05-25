defmodule PhotogWeb.YearController do
    use PhotogWeb, :controller
  
    alias Photog.Api
    alias Photog.Api.Year
  
    action_fallback PhotogWeb.FallbackController

    @doc """
    Returns distinct years that exist for albums
    """
    def albums_years_list(conn, _params) do
      years = Api.distinct_album_years()
      conn
      |> put_view(PhotogWeb.GenericView)
      |> render("data.json", data: years)
    end
    
    def delete(conn, %{"year" => year}) do
        Api.delete_year(year)
        conn
        |> put_view(PhotogWeb.GenericView)
        |> render("ok.json", message: "ok")
    end

    def put(conn, params) do
      with {:ok, %Year{} = year} <- Api.upsert_year(params) do
        conn
        |> put_status(:created)
        |> put_view(PhotogWeb.GenericView)
        |> render("data.json", data: Map.from_struct(year) |> Map.take([:id, :description]))
      end
    end
end
  