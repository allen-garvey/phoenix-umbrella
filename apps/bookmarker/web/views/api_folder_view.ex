defmodule Bookmarker.ApiFolderView do
  use Bookmarker.Web, :view

  @doc """
  Returns JSON array of bookmarks in
  http://jsonapi.org/ json api v1.0 format specification
  """
  def render("bookmarks_for_folder.json", %{bookmarks: bookmarks}) do
    %{
      data: Enum.map(bookmarks, &bookmark_json/1)
    }
  end

  def bookmark_json(bookmark) do
    %{
      id: Integer.to_string(bookmark.id),
      title: bookmark.title,
      url: bookmark.url,
      # rss_url: bookmark.rss_url,
      description: bookmark.description,
      preview_image_selector: bookmark.preview_image_selector,
      thumbnail_url: bookmark.thumbnail_url,
      self: %{
        show: bookmark_path(Bookmarker.Endpoint, :show, bookmark)
      },
    }
  end
end
