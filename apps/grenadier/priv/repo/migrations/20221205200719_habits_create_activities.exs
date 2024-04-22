defmodule Grenadier.Repo.Migrations.HabitsCreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities, prefix: Grenadier.RepoPrefix.habits()) do
      add :title, :text, null: false
      add :description, :text
      add :date, :date, null: false
      add :category_id, references(:categories, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:activities, [:category_id], prefix: Grenadier.RepoPrefix.habits())
  end
end
