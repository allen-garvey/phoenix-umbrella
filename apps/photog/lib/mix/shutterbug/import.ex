defmodule Photog.Shutterbug.Import do
  import Ecto.Query, warn: false
  alias Photog.Api.Import
  alias Photog.Repo

  def create_import do
    import = %Import{}
    |> Import.changeset(%{})
    |> Repo.insert!

    import.id
  end

  def update_cover_image(import_id, image_id) do
    from(i in Import, where: is_nil(i.cover_image_id) and i.id == ^import_id)
    |> Repo.update_all(set: [cover_image_id: image_id])
  end

end
