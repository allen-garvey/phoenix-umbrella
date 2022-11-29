defmodule Booklist.Repo.Migrations.AddGenreToAuthors do
  use Ecto.Migration

  def change do
    alter table(:authors) do
      add :genre_id, references(:genres, on_delete: :nothing)
    end
  end
end
