defmodule Artour.PublicCategoryView do
  use Artour.Web, :view

  @doc """
  Unfortunately can't import this, because it makes the code for getting the display name
  in the shared index messier
  """
  def display_name(category) do
    Artour.CategoryView.display_name category
  end

  @doc """
  Renders list of categories on public site
  """
  def render("index.html", assigns) do
    render Artour.PublicSharedView, "index.html", conn: assigns[:conn], 
                          title: "Categories", 
                          items: assigns[:categories], 
                          item_view: view_module(assigns[:conn]),
                          item_display_func_name: :display_name, 
                          item_path_func_name: :show_path
  end

  @doc """
  Renders page of list of related posts on public site
  """
  def render("show.html", assigns) do
    category = assigns[:category]
    render Artour.PublicSharedView, "index.html", conn: assigns[:conn], 
                          title: display_name(category), 
                          items: category.posts, 
                          item_view: Artour.PublicPostView,
                          item_display_func_name: :display_name, 
                          item_path_func_name: :show_path
  end

  @doc """
  Used to get the path for a category's public show page
  """
  def show_path(conn, category) do
    public_category_path(conn, :show, category.slug)
  end

end
