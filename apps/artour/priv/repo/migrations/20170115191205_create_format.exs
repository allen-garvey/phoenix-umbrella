defmodule Artour.Repo.Migrations.CreateFormat do
  use Ecto.Migration

  def change do
    create table(:formats) do
      add :name, :string

      timestamps()
    end
    create unique_index(:formats, [:name])
  end
end
