defmodule MovielistWeb.PageController do
  use MovielistWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: Routes.movie_path(conn, :index_active))
  end
end
