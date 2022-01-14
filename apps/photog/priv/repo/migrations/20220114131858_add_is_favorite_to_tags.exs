defmodule Photog.Repo.Migrations.AddIsFavoriteToTags do
  use Ecto.Migration

  def change do
    alter table(:tags) do
      add :is_favorite, :boolean, default: false, null: false
    end
  end
end
