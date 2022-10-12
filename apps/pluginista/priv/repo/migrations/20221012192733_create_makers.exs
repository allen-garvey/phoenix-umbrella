defmodule Pluginista.Repo.Migrations.CreateMakers do
  use Ecto.Migration

  def change do
    create table(:makers) do
      add :name, :text, null: false

      timestamps()
    end

    create unique_index(:makers, [:name])
  end
end
