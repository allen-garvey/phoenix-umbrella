defmodule Seren.Repo.Migrations.RemoveGenreFromTracks do
  use Ecto.Migration

  def change do
  	alter table(:tracks) do
  		remove :genre
  	end
  end
end
