defmodule Bookmarker.ApiFolderView do
  use Bookmarker.Web, :view

  @doc """
  Returns JSON array of folders with count of bookmarks in
  http://jsonapi.org/ json api v1.0 format specification
  """
  def render("index.json", %{folders: folders}) do
    %{
      data: Enum.map(folders, &folder_json/1)
    }
  end

  @doc """
  Returns JSON array of bookmarks in
  http://jsonapi.org/ json api v1.0 format specification
  """
  def render("bookmarks_for_folder.json", %{bookmarks: bookmarks}) do
    %{
      data: Enum.map(bookmarks, &bookmark_json/1)
    }
  end

  def folder_json(folder) do
    %{
      id: Integer.to_string(folder.id),
      type: "folder",
      attributes: %{
        name: folder.name,
        description: folder.description,
        bookmark_count: folder.bookmark_count,
      }
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
