defmodule Photog.Repo.Migrations.AddCoverAlbumToTags do
  use Ecto.Migration

  def change do
    alter table(:tags) do
      add :cover_album_id, references(:albums, on_delete: :nothing)
    end
  end
end
