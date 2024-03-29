defmodule Pluginista.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :text, null: false

      timestamps()
    end

    create unique_index(:groups, [:name])
  end
end
