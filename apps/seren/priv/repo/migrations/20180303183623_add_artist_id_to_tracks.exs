defmodule Seren.Repo.Migrations.AddArtistIdToTracks do
  use Ecto.Migration

  def change do
  	alter table(:tracks) do
  		add :artist_id, references(:artists, on_delete: :nothing)
  	end
  end
end
