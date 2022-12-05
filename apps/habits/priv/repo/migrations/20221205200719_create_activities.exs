defmodule Habits.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :title, :text, null: false
      add :description, :text
      add :date, :date, null: false
      add :category_id, references(:categories, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:activities, [:category_id])
  end
end
