defmodule Photog.Shutterbug.Import do
  alias Photog.Api.Import
  alias Photog.Repo

  def create_import do
    import = %Import{}
    |> Import.changeset(%{})
    |> Repo.insert!

    import.id
  end

end
