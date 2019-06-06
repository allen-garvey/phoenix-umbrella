defmodule Photog.Repo.Migrations.MakeAlbumImageOrderOptional do
  use Ecto.Migration

  def change do
  	alter table(:album_images) do
	  modify :image_order, :integer, null: true
	end
  end
end
