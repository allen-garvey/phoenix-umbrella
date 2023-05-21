defmodule Movielist.Repo.Migrations.AddSubtitleToMovies do
  use Ecto.Migration

  def change do
    alter table(:movies) do
      add :subtitle, :text
    end
  end
end
