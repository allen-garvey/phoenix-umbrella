defmodule Bookmarker.PageController do
  use Bookmarker.Web, :controller

  plug(:put_view, html: Bookmarker.PageView)

  def index(conn, _params) do
    render conn, "index.html"
  end
end
