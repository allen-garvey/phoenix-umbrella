defmodule Photog.Repo.Migrations.AddAlbumToYears do
  use Ecto.Migration

  def change do
    alter table(:years) do
      add :album_id, references(:albums, on_delete: :nothing)
    end
  end
end
