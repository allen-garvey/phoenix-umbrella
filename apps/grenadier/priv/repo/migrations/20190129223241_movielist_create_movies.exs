defmodule Grenadier.Repo.Migrations.MovielistCreateMovies do
  use Ecto.Migration

  def change do
    create table(:movies, prefix: Grenadier.RepoPrefix.movielist()) do
      add :title, :text, null: false
      add :sort_title, :text, null: false
      add :theater_release_date, :date
      add :home_release_date, :date
      add :pre_rating, :integer, null: false
      add :is_active, :boolean, default: true, null: false
      add :genre_id, references(:genres, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:movies, [:genre_id], prefix: Grenadier.RepoPrefix.movielist())
  end
end
