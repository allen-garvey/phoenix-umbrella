defmodule Grenadier.Repo.Migrations.ArtourCreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories, prefix: Grenadier.RepoPrefix.artour()) do
      add :name, :string
      add :slug, :string
      add :type, :integer

      timestamps()
    end

    create unique_index(:categories, [:name], prefix: Grenadier.RepoPrefix.artour())
  	create unique_index(:categories, [:slug], prefix: Grenadier.RepoPrefix.artour())
  end
end
