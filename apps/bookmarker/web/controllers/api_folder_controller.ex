defmodule Bookmarker.ApiFolderController do
  use Bookmarker.Web, :controller

  @doc """
  Returns a list of bookmarks in a folder for a given folder name
  """
  def bookmarks_for_folder(conn, %{"folder_id" => folder_id}) do
    bookmarks = Bookmarker.Api.bookmarks_for_folder(folder_id)

    render(conn, "bookmarks_for_folder.json", bookmarks: bookmarks)
  end

end
