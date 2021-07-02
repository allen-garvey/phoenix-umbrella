defmodule Photog.Repo.Migrations.AddDescriptionToAlbums do
  use Ecto.Migration

  def change do
  	alter table(:albums) do
      add :description, :text
    end
  end
end
