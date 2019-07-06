defmodule Artour.PublicCategoryController do
  use Artour.Web, :controller

  alias Artour.Public

  def index(conn, _params) do
    categories = Public.categories_with_posts()
    render conn, "index.html", page_title: "Categories", categories: categories
  end

  @doc """
  Used on public site to show listing of
  individual category's posts
  """
  def show(conn, %{"slug" => slug}) do
    category = Public.get_category_by_slug!(slug)
    render conn, "show.html", page_title: Artour.CategoryView.display_name(category), category: category
  end

end
