defmodule PluginistaWeb.PageController do
  use PluginistaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
