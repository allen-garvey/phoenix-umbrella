defmodule Grenadier.Repo.Migrations.HabitsAddDateIndexToActivities do
  use Ecto.Migration

  def change do
    create index("activities", [:date], prefix: Grenadier.RepoPrefix.habits())
  end
end
