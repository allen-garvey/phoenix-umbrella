defmodule Grenadier.Repo.Migrations.BlockquoteAddReleaseDateToSources do
  use Ecto.Migration

  def change do
  	alter table(:sources, prefix: Grenadier.RepoPrefix.blockquote()) do
      add :release_date, :date
    end
  end
end
