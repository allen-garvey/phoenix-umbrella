defmodule Grenadier.Repo.Migrations.MovielistCreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings, prefix: Grenadier.RepoPrefix.movielist()) do
      add :date_scored, :date, null: false
      add :score, :integer, null: false
      add :movie_id, references(:movies, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:ratings, [:movie_id], prefix: Grenadier.RepoPrefix.movielist())
  end
end
