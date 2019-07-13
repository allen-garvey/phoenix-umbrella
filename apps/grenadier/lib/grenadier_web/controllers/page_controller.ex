defmodule GrenadierWeb.PageController do
  use GrenadierWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, _params) do
    render conn, "login.html", csrf_token: get_csrf_token()
  end
end
