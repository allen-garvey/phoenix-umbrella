defmodule Seren.Repo.Migrations.CreateTracks do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :itunes_id, :integer
      add :title, :text, null: false
      add :artist, :string
      add :genre, :string
      add :date_modified, :utc_datetime
      add :date_added, :utc_datetime
      add :file_type, :string
      add :file_size, :integer
      add :file_path, :text
      add :length, :integer
      add :bit_rate, :integer
      add :sample_rate, :integer
      add :track_number, :integer
      add :relase_year, :integer
      add :album_title, :string
      add :album_disc_number, :integer
      add :album_disc_count, :integer
      add :album_artist, :string
      add :album_track_count, :integer
      add :composer, :string
      add :artwork_count, :integer
      add :play_count, :integer
      add :play_date, :utc_datetime

      timestamps()
    end

  end
end
