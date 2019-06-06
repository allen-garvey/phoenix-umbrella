defmodule Photog.Repo.Migrations.MakeImagesImportIdMandatory do
  use Ecto.Migration

  def change do
    alter table(:images) do
      modify :import_id, :integer, null: false
    end
  end
end
