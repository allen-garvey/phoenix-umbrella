defmodule Photog.Repo.Migrations.AddAmazonIdToImages do
  use Ecto.Migration

  def change do
    alter table(:images) do
      add :amazon_photos_id, :text
    end

    create unique_index(:images, [:amazon_photos_id])
  end
end
