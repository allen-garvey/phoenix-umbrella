defmodule Photog.Repo.Migrations.MakeAlbumsApplePhotosIdOptional do
  use Ecto.Migration

  def change do
  	alter table(:albums) do
	  modify :apple_photos_id, :integer, null: true
	end
  end
end
