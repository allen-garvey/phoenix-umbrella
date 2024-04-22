defmodule Grenadier.Repo.Migrations.BlockquoteAddSortTitleToParentSources do
  use Ecto.Migration

  def change do
  	alter table(:parent_sources, prefix: Grenadier.RepoPrefix.blockquote()) do
      add :sort_title, :string, null: false
    end
    alter table(:sources, prefix: Grenadier.RepoPrefix.blockquote()) do
      add :sort_title, :string, null: false
    end
  end
end
