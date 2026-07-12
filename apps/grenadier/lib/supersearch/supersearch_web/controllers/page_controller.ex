defmodule SupersearchWeb.PageController do
  use GrenadierWeb, :controller

  plug(:put_view, html: SupersearchWeb.PageView)

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
