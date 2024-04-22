defmodule Grenadier.Repo.Migrations.MovielistCreateGenres do
  use Ecto.Migration

  def change do
    create table(:genres, prefix: Grenadier.RepoPrefix.movielist()) do
      add :name, :text, null: false

      timestamps()
    end

    create unique_index(:genres, [:name], prefix: Grenadier.RepoPrefix.movielist())
  end
end
