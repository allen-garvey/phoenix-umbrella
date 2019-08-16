defmodule Bookmarker.Admin do
  import Ecto.Query, warn: false
  alias Bookmarker.Repo
  alias Bookmarker.Folder
  alias Bookmarker.Bookmark

  @doc """
  Returns list of folders with name and id
  ordered in default order suitable for select fields
  for forms
  """
  def folder_form_list do
    from(Folder, order_by: [desc: :is_favorite, asc: :name])
    |> Repo.all
    |> Enum.map(&{&1.name, &1.id})
  end

  @doc """
  Gets favorite folders for use in nav
  """
  def favorite_folders do
    from(f in Folder, where: f.is_favorite == true, order_by: f.name)
    |> Repo.all
  end

  @doc """
  Returns all bookmarks for a given folder_id
  """
  def bookmarks_for_folder(folder_id) do
    from(b in Bookmark, where: b.folder_id == ^folder_id, order_by: [desc: b.id])
    |> Repo.all
  end

end
