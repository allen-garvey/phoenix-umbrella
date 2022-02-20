defmodule Artour.PageController do
  use Artour.Web, :controller

  alias Artour.Public

  @doc """
  Index defaults to first page
  """
  def index(conn, _params) do
    posts = Public.posts_for_homepage()
    
    render(conn, "index.html", posts: posts, main_container_class: "", javascript: true, facebook_image: Enum.fetch!(posts, 0).cover_image)
  end

  @doc """
  Shows list of categories that contain 1 or more related posts
  """
  def browse(conn, _params) do

  	categories = Public.categories_with_posts()
    tags = Public.tags_with_posts()

    render conn, "browse.html", page_title: "Browse", categories: categories, tags: tags
  end

  @doc """
  Displays 404 page
  """
  def error_404(conn, _params) do
    render conn, "404.html", page_title: "404"
  end
end
