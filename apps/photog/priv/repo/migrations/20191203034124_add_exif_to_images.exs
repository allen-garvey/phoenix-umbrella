defmodule Photog.Repo.Migrations.AddExifToImages do
  use Ecto.Migration

  def change do
    alter table(:images) do
      add :exif, :map
    end
  end
end
