defmodule Seren.Repo.Migrations.CreateFileTypes do
  use Ecto.Migration

  def change do
    create table(:file_types) do
      add :name, :text

      timestamps()
    end
    create unique_index(:file_types, [:name])
  end
end
