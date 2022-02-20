defmodule Artour.Repo.Migrations.RemoveFormats do
  use Ecto.Migration

  def change do
    alter table(:images) do
      remove :format_id
    end
  
    drop table(:formats)
  end
end
