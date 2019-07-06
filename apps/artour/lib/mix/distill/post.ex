defmodule Distill.Post do
  alias Distill.PageRoute
  @doc """
  Returns list of tuples in format: path (string), controller module(atom), controller handler function (atom), params (map)
  e.g. {"/posts", Artour.PostController, :index, %{}}
  """
  def routes() do
    Artour.Public.list_posts()
    |> Enum.map(&to_route/1)
  end

  @doc """
  Takes a post struct and returns route tuple
  """
  def to_route(post) do
    %PageRoute{path: "/posts/" <> post.slug, controller: Artour.PublicPostController, handler: :show, params: %{"slug" => post.slug}}
  end
end