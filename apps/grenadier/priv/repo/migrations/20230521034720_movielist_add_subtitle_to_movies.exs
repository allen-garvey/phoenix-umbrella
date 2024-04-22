defmodule Grenadier.Repo.Migrations.MovielistAddSubtitleToMovies do
  use Ecto.Migration

  def change do
    alter table(:movies, prefix: Grenadier.RepoPrefix.movielist()) do
      add :subtitle, :text
    end
  end
end
