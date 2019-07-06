defmodule Artour.Repo.Migrations.AddPublishAttributesToPosts do
  use Ecto.Migration

  def change do
  	alter table(:posts) do
  		add :is_published, :boolean, default: true, null: false
  		add :publication_date, :date
  	end
  end
end
