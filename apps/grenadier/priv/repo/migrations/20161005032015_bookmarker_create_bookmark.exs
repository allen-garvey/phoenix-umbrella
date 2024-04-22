defmodule Grenadier.Repo.Migrations.BookmarkerCreateBookmark do
  use Ecto.Migration

  def change do
    create table(:bookmarks, prefix: Grenadier.RepoPrefix.bookmarker()) do
      add :title, :string
      add :url, :string
      add :description, :string
      add :thumbnail_url, :text
      add :rss_url, :string
  		add :preview_image_selector, :string
      add :folder_id, references(:folders, on_delete: :nothing)

      timestamps()
    end
    create index(:bookmarks, [:folder_id], prefix: Grenadier.RepoPrefix.bookmarker())

  end
end
