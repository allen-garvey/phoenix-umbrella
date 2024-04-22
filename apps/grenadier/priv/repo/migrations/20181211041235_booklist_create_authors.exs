defmodule Grenadier.Repo.Migrations.BooklistCreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors, prefix: Grenadier.RepoPrefix.booklist()) do
      add :first_name, :text, null: false
      add :middle_name, :text
      add :last_name, :text
      add :genre_id, references(:genres, on_delete: :nothing)

      timestamps()
    end

  end
end
