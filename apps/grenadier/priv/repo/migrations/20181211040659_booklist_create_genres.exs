defmodule Grenadier.Repo.Migrations.BooklistCreateGenres do
  use Ecto.Migration

  def change do
    create table(:genres, prefix: Grenadier.RepoPrefix.booklist()) do
      add :name, :text, null: false
      add :is_fiction, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:genres, [:name], prefix: Grenadier.RepoPrefix.booklist())

  end
end
