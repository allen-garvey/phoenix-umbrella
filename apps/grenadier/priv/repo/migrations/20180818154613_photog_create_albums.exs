defmodule Grenadier.Repo.Migrations.PhotogCreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums, prefix: Grenadier.RepoPrefix.photog()) do
      add :name, :text, null: false
      add :cover_image_id, references(:images, on_delete: :nothing), null: false
      add :year, :integer, default: Date.utc_today().year, null: false
      add :is_favorite, :boolean, default: false, null: false
      add :description, :text

      timestamps()
    end
S
    create index(:albums, [:cover_image_id], prefix: Grenadier.RepoPrefix.photog())
    create index(:albums, [:year], prefix: Grenadier.RepoPrefix.photog())
  end
end
