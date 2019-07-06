defmodule Artour.PublicTagView do
  use Artour.Web, :view

  @doc """
  Unfortunately can't import this, because it makes the code for getting the display name
  in the shared index messier
  """
  def display_name(tag) do
    Artour.TagView.display_name tag
  end

  @doc """
  Renders list of tags on public site
  """
  def render("index.html", assigns) do
    render Artour.PublicSharedView, "index.html", conn: assigns[:conn], 
    											title: "Tags", 
    											items: assigns[:tags], 
    											item_view: Artour.PublicTagView,
    											item_display_func_name: :display_name, 
    											item_path_func_name: :show_path
  end

  @doc """
  Renders page of list of related posts on public site
  """
  def render("show.html", assigns) do
    tag = assigns[:tag]
    render Artour.PublicSharedView, "index.html", conn: assigns[:conn], 
    											title: display_name(tag), 
    											items: tag.posts, 
    											item_view: Artour.PublicPostView,
    											item_display_func_name: :display_name, 
    											item_path_func_name: :show_path

  end

  @doc """
  Used to get the path for a tags's public show page
  """
  def show_path(conn, tag) do
    public_tag_path(conn, :show, tag.slug)
  end
end
