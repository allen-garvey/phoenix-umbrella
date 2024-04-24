defmodule Artour.PageController do
  use Artour.Web, :controller

  alias Artour.Public

  @doc """
  Displays all posts, images are lazy loaded
  """
  def index(conn, _params) do
    posts = Public.posts_for_homepage()

    facebook_image = case Enum.fetch(posts, 0) do
      {:ok, post} -> post.cover_image
      _ -> nil
    end
    
    render(conn, "index.html", posts: posts, main_container_class: "", javascript: true, facebook_image: facebook_image)
  end

  @doc """
  Displays 404 page
  """
  def error_404(conn, _params) do
    render conn, "404.html", page_title: "404"
  end
end
