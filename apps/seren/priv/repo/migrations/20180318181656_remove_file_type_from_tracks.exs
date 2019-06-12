defmodule Seren.Repo.Migrations.RemoveFileTypeFromTracks do
  use Ecto.Migration

  def change do
  	alter table(:tracks) do
  		remove :file_type
  	end
  end
end
