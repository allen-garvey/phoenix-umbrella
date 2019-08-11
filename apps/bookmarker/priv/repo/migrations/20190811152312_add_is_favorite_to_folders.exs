defmodule Bookmarker.Repo.Migrations.AddIsFavoriteToFolders do
  use Ecto.Migration

  def change do
    alter table(:folders) do
  		add :is_favorite, :boolean, null: false, default: false
  	end
  end
end
