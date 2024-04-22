defmodule Grenadier.Repo.Migrations.BooklistCreateBooks do
  use Ecto.Migration

  def change do
    create table(:books, prefix: Grenadier.RepoPrefix.booklist()) do
      add :title, :text, null: false
      add :sort_title, :text, null: false
      add :subtitle, :text
      add :is_fiction, :boolean, default: false, null: false
      add :is_active, :boolean, default: true, null: false
      add :on_bookshelf, :boolean, default: false, null: false
      add :author_id, references(:authors, on_delete: :nothing)
      add :genre_id, references(:genres, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:books, [:author_id], prefix: Grenadier.RepoPrefix.booklist())
    create index(:books, [:genre_id], prefix: Grenadier.RepoPrefix.booklist())
  end
end
