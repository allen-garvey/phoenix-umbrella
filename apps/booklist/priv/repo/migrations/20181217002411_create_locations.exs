defmodule Booklist.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :text, null: false
      add :library_id, references(:libraries, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:locations, [:library_id])
  end
end
