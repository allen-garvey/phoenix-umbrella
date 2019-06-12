defmodule Seren.Repo.Migrations.AddComposerIdToTracks do
  use Ecto.Migration

  def change do
  	alter table(:tracks) do
  		add :composer_id, references(:composers, on_delete: :nothing)
  	end
  end
end
