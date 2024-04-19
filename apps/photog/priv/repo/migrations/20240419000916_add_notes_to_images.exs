defmodule Photog.Repo.Migrations.AddNotesToImages do
  use Ecto.Migration

  def change do
    alter table(:images) do
      add :notes, :text
    end
  end
end
