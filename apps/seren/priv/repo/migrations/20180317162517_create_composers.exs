defmodule Seren.Repo.Migrations.CreateComposers do
  use Ecto.Migration

  def change do
    create table(:composers) do
      add :name, :text

      timestamps()
    end
    create unique_index(:composers, [:name])
  end
end
