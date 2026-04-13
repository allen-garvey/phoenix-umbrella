defmodule Artour.AdminController do
  use Artour.Web, :controller

  plug(:put_view, html: Artour.AdminView)

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
