defmodule Distill.Tag do
  alias Distill.PageRoute
  @doc """
  Returns list of tuples in format: path (string), controller module(atom), controller handler function (atom), params (map)
  e.g. {"/posts", Artour.PostController, :index, %{}}
  """
  def routes() do
    Artour.Public.tags_with_posts() 
    |> Enum.map(&to_route/1)
  end

  @doc """
  Takes a tag struct and returns route tuple
  """
  def to_route(tag) do
    %PageRoute{path: "/tags/" <> tag.slug, controller: Artour.PublicTagController, handler: :show, params: %{"slug" => tag.slug}}
  end
end