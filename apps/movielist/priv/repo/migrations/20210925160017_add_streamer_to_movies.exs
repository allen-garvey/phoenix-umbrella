defmodule Movielist.Repo.Migrations.AddStreamerToMovies do
  use Ecto.Migration

  def change do
    alter table(:movies) do
      add :streamer_id, references(:streamers, on_delete: :nothing)
    end
  end
end
