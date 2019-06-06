defmodule Photog.Repo.Migrations.AllowImagesApplePhotosIdNull do
  use Ecto.Migration

  def change do
  	alter table(:images) do
	  modify :apple_photos_id, :integer, null: true
	end
  end
end
