defmodule Booklist.Repo.Migrations.CreateLoans do
  use Ecto.Migration

  def change do
    create table(:loans) do
      add :due_date, :date, null: false
      add :item_count, :integer, null: false
      add :library_id, references(:libraries, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:loans, [:library_id])
  end
end
