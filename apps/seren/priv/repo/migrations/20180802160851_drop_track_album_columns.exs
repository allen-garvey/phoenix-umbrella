# drops columns from tracks that are now normalized in albums table
defmodule Seren.Repo.Migrations.DropTrackAlbumColumns do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      remove :album_title
      remove :album_artist_id
      remove :album_artist
  	end
  end
end
