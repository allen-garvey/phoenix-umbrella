defmodule Bookmarker.Repo.Migrations.AddThumbnailImageToBookmarks do
  use Ecto.Migration

  def change do
  	alter table(:bookmarks) do
  		add :thumbnail_url, :text
  	end
  end
end
