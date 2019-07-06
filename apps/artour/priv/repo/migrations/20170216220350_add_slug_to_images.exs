defmodule Artour.Repo.Migrations.AddSlugToImages do
  use Ecto.Migration

  def change do
  	alter table(:images) do
      add :slug, :text
    end
    create unique_index(:images, [:slug])
  end
end
