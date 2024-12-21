defmodule Grenadier.Repo.Migrations.HabitsAddIsFavoriteToCategories do
  use Ecto.Migration

  def change do
    alter table(:categories, prefix: Grenadier.RepoPrefix.habits()) do
      add :is_favorite, :boolean, default: false, null: false
    end
  end
end
