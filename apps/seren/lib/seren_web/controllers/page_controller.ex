defmodule SerenWeb.PageController do
  use SerenWeb, :controller

  plug(:put_view, html: SerenWeb.PageView)

  def index(conn, _params) do
    render conn, "index.html"
  end
end
