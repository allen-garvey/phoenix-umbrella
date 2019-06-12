defmodule Seren.Repo.Migrations.RenameTracksReleaseYear do
  use Ecto.Migration

  def change do
    rename table("tracks"), :relase_year, to: :release_year
  end
end
