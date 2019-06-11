defmodule Bookmarker.Repo.Migrations.AddPreviewFieldsToBookmarks do
  use Ecto.Migration

  def change do
  	alter table(:bookmarks) do
  		add :rss_url, :string
  		add :preview_image_selector, :string
  	end
  end
end
