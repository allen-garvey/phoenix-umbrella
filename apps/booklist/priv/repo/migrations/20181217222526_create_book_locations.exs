defmodule Booklist.Repo.Migrations.CreateBookLocations do
  use Ecto.Migration

  def change do
    create table(:book_locations) do
      add :call_number, :text
      add :book_id, references(:books, on_delete: :nothing), null: false
      add :location_id, references(:locations, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:book_locations, [:book_id])
    create index(:book_locations, [:location_id])
  end
end
