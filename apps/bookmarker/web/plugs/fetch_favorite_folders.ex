defmodule Bookmarker.Plugs.FetchFavoriteFolders do
  import Plug.Conn

  alias Bookmarker.Admin

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn
    |> assign(:favorite_folders, Admin.favorite_folders())
  end
end
