defmodule Grenadier.Repo.Migrations.BookmarkerCreateBookmarkTag do
  use Ecto.Migration

  def change do
    create table(:bookmarks_tags, prefix: Grenadier.RepoPrefix.bookmarker()) do
      add :bookmark_id, references(:bookmarks, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)

      timestamps()
    end
    create index(:bookmarks_tags, [:bookmark_id], prefix: Grenadier.RepoPrefix.bookmarker())
    create index(:bookmarks_tags, [:tag_id], prefix: Grenadier.RepoPrefix.bookmarker())
    create unique_index(:bookmarks_tags, [:bookmark_id, :tag_id], name: "bookmark_tag_composite", prefix: Grenadier.RepoPrefix.bookmarker())

  end
end
