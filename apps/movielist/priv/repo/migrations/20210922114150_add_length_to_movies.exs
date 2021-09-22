defmodule Movielist.Repo.Migrations.AddLengthToMovies do
  use Ecto.Migration

  def change do
    alter table(:movies) do
      add :length, :integer
    end
  end
end
