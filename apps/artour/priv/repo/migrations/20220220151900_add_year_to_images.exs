defmodule Artour.Repo.Migrations.AddYearToImages do
  use Ecto.Migration

  def change do
    alter table(:images) do
  		add :year, :integer
  	end
  end
end
