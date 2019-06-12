defmodule Seren.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  # use this query to populate albums
  # INSERT INTO albums (title, artist_id, inserted_at, updated_at) select distinct album_title, coalesce(album_artist_id, artist_id), now(), now() from tracks where album_title is not null;

  def change do
    create table(:albums) do
      add :title, :text
      add :artist_id, references(:artists, on_delete: :nothing)

      timestamps()
    end

    create index(:albums, [:artist_id])
  end
end
