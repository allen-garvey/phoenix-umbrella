defmodule Seren.Repo.Migrations.AddGenreIdToTracks do
  use Ecto.Migration

  def change do
  	alter table(:tracks) do
  		add :genre_id, references(:genres, on_delete: :nothing)
  	end
  end
end
