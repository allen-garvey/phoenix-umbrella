defmodule Seren.Repo.Migrations.AddAlbumIdToTracks do
  use Ecto.Migration

  # update tracks album_id with this query
  # update tracks set album_id = (select albums.id from albums where albums.title = tracks.album_title and albums.artist_id = coalesce(tracks.album_artist_id, tracks.artist_id) limit 1), updated_at = now() where album_title is not null;

  def change do
    alter table(:tracks) do
  		add :album_id, references(:albums, on_delete: :nothing)
  	end
  end
end
