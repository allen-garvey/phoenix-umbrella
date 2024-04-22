defmodule Grenadier.Repo.Migration.SerenCreateArtists do
  use Ecto.Migration

  def change do
    create table(:artists, prefix: Grenadier.RepoPrefix.seren()) do
      add :name, :text

      timestamps()
    end
    create unique_index(:artists, [:name], prefix: Grenadier.RepoPrefix.seren())
  end
end
