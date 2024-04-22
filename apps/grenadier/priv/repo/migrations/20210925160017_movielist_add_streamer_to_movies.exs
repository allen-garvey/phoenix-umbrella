defmodule Grenadier.Repo.Migrations.MovielistAddStreamerToMovies do
  use Ecto.Migration

  def change do
    alter table(:movies, prefix: Grenadier.RepoPrefix.movielist()) do
      add :streamer_id, references(:streamers, on_delete: :nothing)
    end
  end
end
