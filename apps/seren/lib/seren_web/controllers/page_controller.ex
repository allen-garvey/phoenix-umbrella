defmodule SerenWeb.PageController do
  use SerenWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
