defmodule HabitsWeb.PageController do
  use HabitsWeb, :controller
  plug(:put_view, html: HabitsWeb.PageView)

  def calendar(conn, _params) do
    render(conn, "calendar.html", no_main_padding: true)
  end
end
