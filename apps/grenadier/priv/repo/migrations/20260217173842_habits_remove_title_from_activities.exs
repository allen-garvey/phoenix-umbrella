defmodule Grenadier.Repo.Migrations.HabitsRemoveTitleFromActivities do
  use Ecto.Migration

  def change do
    alter table(:activities, prefix: Grenadier.RepoPrefix.habits()) do
      remove :title
    end
  end
end
