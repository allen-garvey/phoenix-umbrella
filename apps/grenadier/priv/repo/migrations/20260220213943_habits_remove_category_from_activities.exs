defmodule Grenadier.Repo.Migrations.HabitsRemoveCategoryFromActivities do
  use Ecto.Migration

  def change do
    alter table(:activities, prefix: Grenadier.RepoPrefix.habits()) do
      remove :category_id
    end
  end
end
