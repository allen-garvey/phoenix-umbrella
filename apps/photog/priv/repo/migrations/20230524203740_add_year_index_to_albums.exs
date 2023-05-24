defmodule Photog.Repo.Migrations.AddYearIndexToAlbums do
  use Ecto.Migration

  def change do
    create index(:albums, [:year])
  end
end
