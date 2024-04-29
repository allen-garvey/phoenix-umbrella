defmodule Grenadier.Repo.Migrations.PhotogAddIsFavoriteToPersons do
  use Ecto.Migration

  def change do
    alter table(:persons, prefix: Grenadier.RepoPrefix.photog()) do
      add :is_favorite, :boolean, default: false, null: false
    end
  end
end
