defmodule Bookmarker.Repo.Migrations.AddBookmarksTagsUniqueIndex do
  use Ecto.Migration

  def change do
  	create unique_index(:bookmarks_tags, [:bookmark_id, :tag_id], name: "bookmark_tag_composite")
  end
end
