defmodule Grenadier.Repo.Migrations.MovielistCreateStreamers do
  use Ecto.Migration

  def change do
    create table(:streamers, prefix: Grenadier.RepoPrefix.movielist()) do
      add :name, :text, null: false

      timestamps()
    end

    create unique_index(:streamers, [:name], prefix: Grenadier.RepoPrefix.movielist())
  end
end
