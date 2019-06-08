defmodule BlockquoteWeb.AdminController do
  use BlockquoteWeb, :controller
  
  def index(conn, _params) do
    fields = ["author", "category", "daily quote", "quote", "parent source", "source", "source type"]
    render(conn, "index.html", fields: fields)
  end
end