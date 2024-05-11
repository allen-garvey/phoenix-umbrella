defmodule Bookmarker.Api do
    import Ecto.Query
    alias Grenadier.Repo
    alias Bookmarker.Bookmark
  
    @doc """
    Returns all bookmarks for a given folder_id
    """
    def bookmarks_for_folder(folder_id) do
      from(
        b in Bookmark, 
        where: b.folder_id == ^folder_id, 
        order_by: [desc: b.id]
      )
      |> Repo.all
    end
  
  end
  