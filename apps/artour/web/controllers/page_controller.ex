defmodule Artour.PageController do
  use Artour.Web, :controller

  alias Artour.Public

  @doc """
  Index defaults to first page
  """
  def index(conn, _params) do
    page conn, %{"page_num" => 1}
  end

  @doc """
  Displays single page of paginated index
  """
  def page(conn, %{"page_num" => page_num}) do
    last_page = Public.last_page
    #no checking if page_num is valid or in range, because final product will be static site
    page_num = cond do
                  is_integer(page_num) -> page_num
                  true -> String.to_integer page_num
              end

    posts = Public.posts_for_page(page_num)
    render conn, "index.html", posts: posts, current_page: page_num, last_page: last_page, main_container_class: "", javascript: true, facebook_image: Enum.fetch!(posts, 0).cover_image
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
