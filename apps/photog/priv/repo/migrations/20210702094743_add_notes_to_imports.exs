defmodule Photog.Repo.Migrations.AddNotesToImports do
  use Ecto.Migration

  def change do
    alter table(:imports) do
      add :notes, :text
    end
  end
end
