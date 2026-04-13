defmodule MovielistWeb.PageController do
  use MovielistWeb, :controller

  plug(:put_view, html: MovielistWeb.PageView)

  def index(conn, _params) do
    conn
    |> redirect(to: Routes.movie_path(conn, :index_active))
  end
end
