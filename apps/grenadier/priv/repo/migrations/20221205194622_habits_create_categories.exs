defmodule Grenadier.Repo.Migrations.HabitsCreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, prefix: Grenadier.RepoPrefix.habits()) do
      add :name, :text, null: false
      add :color, :text

      timestamps()
    end

    create unique_index(:categories, [:name], prefix: Grenadier.RepoPrefix.habits())
  end
end
