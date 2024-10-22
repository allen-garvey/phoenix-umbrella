defmodule Grenadier.Repo.Migrations.BookmarkerRemoveTags do
  use Ecto.Migration

  def change do
    drop table(:bookmarks_tags, prefix: Grenadier.RepoPrefix.bookmarker())
    drop table(:tags, prefix: Grenadier.RepoPrefix.bookmarker())
  end
end
