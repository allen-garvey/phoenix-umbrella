defmodule Seren.Repo.Migrations.RemoveComposerFromTracks do
  use Ecto.Migration

  def change do
  	alter table(:tracks) do
  		remove :composer
  	end
  end
end
