defmodule Grenadier.Repo.Migrations.ArtourCreateTag do
  use Ecto.Migration

  def change do
    create table(:tags, prefix: Grenadier.RepoPrefix.artour()) do
      add :name, :string
      add :slug, :string

      timestamps()
    end
    create unique_index(:tags, [:name], prefix: Grenadier.RepoPrefix.artour())
  	create unique_index(:tags, [:slug], prefix: Grenadier.RepoPrefix.artour())
  end
end
