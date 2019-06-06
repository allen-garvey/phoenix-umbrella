defmodule Photog.Repo.Migrations.AddApplePhotosUuidToImports do
  use Ecto.Migration

  def change do
    alter table(:imports) do
      add :apple_photos_uuid, :text
    end
    create unique_index(:imports, [:apple_photos_uuid])
  end
end
