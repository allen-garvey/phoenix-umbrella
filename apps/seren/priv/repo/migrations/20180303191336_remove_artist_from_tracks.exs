defmodule Seren.Repo.Migrations.RemoveArtistFromTracks do
  use Ecto.Migration

  def change do
  	alter table(:tracks) do
  		remove :artist
  	end
  end
end
