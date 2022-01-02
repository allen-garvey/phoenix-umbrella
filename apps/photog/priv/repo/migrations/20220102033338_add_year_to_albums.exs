
defmodule Photog.Repo.Migrations.AddYearToAlbums do
  use Ecto.Migration
  alias Common.ModelHelpers.Date

  def change do
    alter table(:albums) do
      add :year, :integer, default: Date.now().year, null: false
    end
  end
end
