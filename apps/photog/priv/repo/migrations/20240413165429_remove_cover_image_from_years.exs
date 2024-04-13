defmodule Photog.Repo.Migrations.RemoveCoverImageFromYears do
  use Ecto.Migration

  def change do
    alter table(:years) do
      remove :cover_image_id
    end
  end
end
