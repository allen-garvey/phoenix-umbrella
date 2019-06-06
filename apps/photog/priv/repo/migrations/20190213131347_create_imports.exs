defmodule Photog.Repo.Migrations.CreateImports do
  use Ecto.Migration

  def change do
    create table(:imports) do
      add :import_time, :utc_datetime, null: false

      timestamps()
    end

  end
end
