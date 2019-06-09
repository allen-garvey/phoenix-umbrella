defmodule Mix.Tasks.Teamster do
  use Mix.Task

  import Ecto.Query, warn: false

  alias Movielist.Repo
  alias Movielist.RepoLegacy

  @moduledoc """
  Mix tasks to migrate the book_list rails database data to the booklist phoenix application 
  """

  @shortdoc "Migrates data from book_list rails to current booklist phoenix application"
  def run(_) do
    # start app so repo is available
    # make sure RepoLegacy is started in application.ex
    Mix.Task.run "app.start", []

    migrate_genres(Teamster.Models.LegacyGenre)
    migrate(Teamster.Models.LegacyMovie)

    migrate_ratings()
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

  # because we can't dynamically send the order_by atom for some reason
  defp migrate_genres(model_module) when is_atom(model_module) do
    from(model_module, order_by: [:genre_id])
      |> RepoLegacy.all
      |> migrate_legacy_models(model_module)
  end

  defp migrate_ratings do
    from(m in Teamster.Models.LegacyMovie, where: not is_nil(m.post_rating), order_by: m.date_watched)
    |> RepoLegacy.all
    |> migrate_legacy_models(Teamster.Models.LegacyRating)
  end
end