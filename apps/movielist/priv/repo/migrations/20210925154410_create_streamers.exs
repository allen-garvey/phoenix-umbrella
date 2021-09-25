defmodule Movielist.Repo.Migrations.CreateStreamers do
  use Ecto.Migration

  def change do
    create table(:streamers) do
      add :name, :text, null: false

      timestamps()
    end

    create unique_index(:streamers, [:name])
  end
end
