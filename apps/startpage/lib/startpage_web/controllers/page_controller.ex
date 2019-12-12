defmodule StartpageWeb.PageController do
  use StartpageWeb, :controller

  def index(conn, _params) do
    folders = Startpage.Admin.list_folders_in_order()
    render(conn, "index.html", folders: folders)
  end
end
