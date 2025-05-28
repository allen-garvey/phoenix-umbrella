defmodule Grenadier.Repo.Migrations.PhotogRemoveCompletionDateFromImages do
  use Ecto.Migration

  def change do
    alter table(:images, prefix: Grenadier.RepoPrefix.photog()) do
      remove :completion_date
    end
  end
end
