defmodule Distill.Category do
  alias Distill.PageRoute
  @doc """
  Returns list of tuples in format: path (string), controller module(atom), controller handler function (atom), params (map)
  e.g. {"/posts", Artour.PostController, :index, %{}}
  """
  def routes() do
    Artour.Public.categories_with_posts()
    |> Enum.map(&to_route/1)
  end

  @doc """
  Takes a category struct and returns route tuple
  """
  def to_route(category) do
    %PageRoute{path: "/categories/" <> category.slug, controller: Artour.PublicCategoryController, handler: :show, params: %{"slug" => category.slug}}
  end
end