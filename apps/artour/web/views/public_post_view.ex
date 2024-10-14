defmodule Artour.PublicPostView do
  use Artour.Web, :view

  @doc """
  Unfortunately can't import this, because it makes the code for getting the display name
  in the shared index messier
  """
  def display_name(post) do
    Artour.PostView.display_name post
  end

  @doc """
  Used to get the path for a post's public show page
  """
  def show_path(conn, post) do
    public_post_path(conn, :show, post.slug)
  end

  def formatted_post_body(nil, _is_markdown) do
    nil
  end

  def formatted_post_body(post_body, is_markdown) when is_binary(post_body) and is_boolean(is_markdown) do
		if is_markdown do
			post_body 
      |> html_escape 
      |> safe_to_string 
      |> expand_markdown_links 
      |> raw
		else
			to_paragraphs(post_body)
		end 
  end

  def expand_markdown_links(body) when is_binary(body) do
    Regex.replace(~r/\[([^\]]+)\]\(([^\)]+)\)/, body, fn _, text, url -> "<a#{attributes_escape(href: url) |> safe_to_string}>#{text}</a>" end)
  end

  @doc """
  Renders page of list of all posts in 
  """
  def render("index.html", assigns) do
    render Artour.PublicSharedView, "index.html", conn: assigns[:conn], 
                          title: "Posts", 
                          items: assigns[:posts], 
                          item_view: Artour.PublicPostView,
                          item_display_func_name: :display_name, 
                          item_path_func_name: :show_path
  end
end
