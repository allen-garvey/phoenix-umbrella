defmodule Habits.Repo.Migrations.AddDateIndexToActivities do
  use Ecto.Migration

  def change do
    create index("activities", [:date])
  end
end
