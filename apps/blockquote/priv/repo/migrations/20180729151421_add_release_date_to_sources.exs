defmodule Blockquote.Repo.Migrations.AddReleaseDateToSources do
  use Ecto.Migration

  def change do
  	alter table(:sources) do
      add :release_date, :date
    end
  end
end
