defmodule Grenadier.Repo.Migration.SerenCreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums, prefix: Grenadier.RepoPrefix.seren()) do
      add :title, :text
      add :artist_id, references(:artists, on_delete: :nothing)

      timestamps()
    end

    create index(:albums, [:artist_id], prefix: Grenadier.RepoPrefix.seren())
  end
end
