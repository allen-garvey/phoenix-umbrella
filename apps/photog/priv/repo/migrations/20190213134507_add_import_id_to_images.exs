defmodule Photog.Repo.Migrations.AddImportIdToImages do
  use Ecto.Migration

  def change do
  	alter table(:images) do
	  add :import_id, references(:imports, on_delete: :nothing)
	end
  end
end
