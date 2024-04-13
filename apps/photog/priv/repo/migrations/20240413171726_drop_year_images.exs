defmodule Photog.Repo.Migrations.DropYearImages do
  use Ecto.Migration

  def change do
    drop table(:year_images)
  end
end
