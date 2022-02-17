defmodule Photog.Repo.Migrations.AddIsFavoriteToAlbums do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add :is_favorite, :boolean, default: false, null: false
    end
  end
end
