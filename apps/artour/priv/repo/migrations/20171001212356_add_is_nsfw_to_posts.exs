defmodule Artour.Repo.Migrations.AddIsNsfwToPosts do
  use Ecto.Migration

  def change do
  	alter table(:posts) do
  		add :is_nsfw, :boolean, default: false
  	end
  end
end
