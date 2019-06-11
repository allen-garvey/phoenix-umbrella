defmodule Bookmarker.Repo.Migrations.CreateBookmark do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :title, :string
      add :url, :string
      add :description, :string
      add :folder_id, references(:folders, on_delete: :nothing)

      timestamps()
    end
    create index(:bookmarks, [:folder_id])

  end
end
