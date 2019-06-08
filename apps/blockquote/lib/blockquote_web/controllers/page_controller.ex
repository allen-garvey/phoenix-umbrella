defmodule BlockquoteWeb.PageController do
  use BlockquoteWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
