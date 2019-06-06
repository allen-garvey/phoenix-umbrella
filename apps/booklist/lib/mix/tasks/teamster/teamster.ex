defmodule Mix.Tasks.Teamster do
  use Mix.Task

  import Ecto.Query, warn: false

  alias Booklist.Repo
  alias Booklist.RepoLegacy

  @moduledoc """
  Mix tasks to migrate the book_list rails database data to the booklist phoenix application 
  """

  @shortdoc "Migrates data from book_list rails to current booklist phoenix application"
  def run(_) do
    # start app so repo is available
    # make sure RepoLegacy is started in application.ex
    Mix.Task.run "app.start", []

    migrate(Teamster.Models.LegacyAuthor)
    migrate(Teamster.Models.LegacyGenre)
    migrate(Teamster.Models.LegacyLibrary)
    migrate(Teamster.Models.LegacyLocation)
    migrate(Teamster.Models.LegacyLoan)
    migrate(Teamster.Models.LegacyBook)
    migrate(Teamster.Models.LegacyBookLocation)
    migrate(Teamster.Models.LegacyRating)
  end

  defp migrate(model_module) when is_atom(model_module) do
  	from(model_module, order_by: [:id])
  		|> RepoLegacy.all
  		|> migrate_legacy_models(model_module)
  end

  defp migrate_legacy_models(legacy_models, module_name) when is_atom(module_name) do
  	for legacy_model <- legacy_models do
		Kernel.apply(module_name, :migrate, [legacy_model])
			|> Repo.insert!
    end
  end
end