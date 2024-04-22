defmodule Grenadier.Repo.Migrations.BooklistCreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations, prefix: Grenadier.RepoPrefix.booklist()) do
      add :name, :text, null: false
      add :library_id, references(:libraries, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:locations, [:library_id], prefix: Grenadier.RepoPrefix.booklist())
  end
end
