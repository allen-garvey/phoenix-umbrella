defmodule Habits.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :text, null: false
      add :color, :text

      timestamps()
    end

    create unique_index(:categories, [:name])
  end
end
