defmodule Artour.Repo.Migrations.RemoveSlugFromImages do
  use Ecto.Migration

  def change do
    alter table(:images) do
      remove :slug
    end
  end
end
