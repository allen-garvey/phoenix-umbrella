defmodule Seren.Repo.Migrations.AddAlbumArtistIdToTracks do
  use Ecto.Migration

  #normalize tracks album_artist
  #use this query to update the tracks:
  #update tracks set album_artist_id = (select artists.id from artists where artists.name=tracks.album_artist limit 1) where tracks.album_artist is not null;

  def change do
    alter table(:tracks) do
  		add :album_artist_id, references(:artists, on_delete: :nothing)
  	end
  end
end
