defmodule SupersearchWeb.PageController do
  use GrenadierWeb, :controller
  alias Supersearch.Admin

  plug(:put_view, html: SupersearchWeb.PageView)

  def index(conn, %{"q" => query}) do
    engines = Admin.list_engines()

    render(conn, "search_results.html", query: query, engines: engines)
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
