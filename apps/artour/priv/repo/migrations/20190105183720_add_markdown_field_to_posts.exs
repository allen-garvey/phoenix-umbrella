defmodule Artour.Repo.Migrations.AddMarkdownFieldToPosts do
  use Ecto.Migration

  def change do
  	alter table(:posts) do
  		add :is_markdown, :boolean, default: false, null: false
  	end
  end
end
