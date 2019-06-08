defmodule Blockquote.Repo.Migrations.AddSortTitleToParentSources do
  use Ecto.Migration

  def change do
  	alter table(:parent_sources) do
      add :sort_title, :string, null: false
    end
    alter table(:sources) do
      add :sort_title, :string, null: false
    end
  end
end
