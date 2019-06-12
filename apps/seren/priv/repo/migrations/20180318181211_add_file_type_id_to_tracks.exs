defmodule Seren.Repo.Migrations.AddFileTypeIdToTracks do
  use Ecto.Migration

  def change do
  	alter table(:tracks) do
  		add :file_type_id, references(:file_types, on_delete: :nothing)
  	end
  end
end
