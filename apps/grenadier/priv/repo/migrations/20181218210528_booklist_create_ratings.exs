defmodule Grenadier.Repo.Migrations.BooklistCreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings, prefix: Grenadier.RepoPrefix.booklist()) do
      add :date_scored, :date, null: false
      add :score, :integer, null: false
      add :book_id, references(:books, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:ratings, [:book_id], prefix: Grenadier.RepoPrefix.booklist())
  end
end
