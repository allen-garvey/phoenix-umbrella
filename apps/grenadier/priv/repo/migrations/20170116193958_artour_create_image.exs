defmodule Grenadier.Repo.Migrations.ArtourCreateImage do
  use Ecto.Migration

  def change do
    create table(:images, prefix: Grenadier.RepoPrefix.artour()) do
      add :title, :string
      add :description, :string
      add :filename_large, :string
      add :filename_medium, :string
      add :filename_small, :string
      add :filename_thumbnail, :string
      add :completion_date, :date
      add :year, :integer

      timestamps()
    end
    create unique_index(:images, [:title], prefix: Grenadier.RepoPrefix.artour())
  end
end
