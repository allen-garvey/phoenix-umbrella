defmodule HabitsWeb.PageController do
  use HabitsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
