defmodule Grenadier.Repo.Migrations.MovielistAddLengthToMovies do
  use Ecto.Migration

  def change do
    alter table(:movies, prefix: Grenadier.RepoPrefix.movielist()) do
      add :length, :integer
    end
  end
end
