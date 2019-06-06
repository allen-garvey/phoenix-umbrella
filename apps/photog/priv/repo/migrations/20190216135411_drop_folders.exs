defmodule Photog.Repo.Migrations.DropFolders do
  use Ecto.Migration

  def change do
  	alter table(:albums) do
	  remove :folder_order
	  remove :folder_id
	end

  	drop table(:folders)
  end
end
