defmodule Bookmarker.ApiFolderController do
  use Bookmarker.Web, :controller

  alias Bookmarker.Folder
  alias Bookmarker.Api

  def index(conn, _params) do
    folders = Folder.with_bookmarks_count_query |> Repo.all

    render(conn, "index.json", folders: folders)
  end

  @doc """
  Returns a list of bookmarks in a folder for a given folder name
  """
  def bookmarks_for_folder(conn, %{"folder_id" => folder_id}) do
    bookmarks = Api.bookmarks_for_folder(folder_id)

    render(conn, "bookmarks_for_folder.json", bookmarks: bookmarks)
  end

end
