defmodule Grenadier.Repo.Migration.SerenCreateTracks do
  use Ecto.Migration

  def change do
    create table(:tracks, prefix: Grenadier.RepoPrefix.seren()) do
      add :itunes_id, :integer
      add :title, :text, null: false
      add :date_modified, :utc_datetime
      add :date_added, :utc_datetime
      add :file_size, :integer
      add :file_path, :text
      add :length, :integer
      add :bit_rate, :integer
      add :sample_rate, :integer
      add :track_number, :integer
      add :release_year, :integer
      add :album_disc_number, :integer
      add :album_disc_count, :integer
      add :album_track_count, :integer
      add :artwork_count, :integer
      add :play_count, :integer
      add :play_date, :utc_datetime

      add :album_id, references(:albums, on_delete: :nothing)
      add :artist_id, references(:artists, on_delete: :nothing)
      add :composer_id, references(:composers, on_delete: :nothing)
      add :file_type_id, references(:file_types, on_delete: :nothing)
      add :genre_id, references(:genres, on_delete: :nothing)

      timestamps()
    end

  end
end
