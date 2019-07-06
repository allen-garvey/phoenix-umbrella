defmodule Artour.AdminController do
  use Artour.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
