defmodule HabitsWeb.Plugs.FetchFavoriteCategories do
  import Plug.Conn

  alias Habits.Admin

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn
    |> assign(:favorite_categories, Admin.list_favorite_categories())
  end
end
