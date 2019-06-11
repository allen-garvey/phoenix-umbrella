defmodule Bookmarker.PageController do
  use Bookmarker.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
