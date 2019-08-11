defmodule Bookmarker.Admin do
  import Ecto.Query, warn: false
  alias Bookmarker.Repo
  alias Bookmarker.Folder

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

end
