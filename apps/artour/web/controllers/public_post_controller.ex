defmodule Artour.PublicPostController do
  use Artour.Web, :controller

  @doc """
  Used on public site to show individual post
  """
  def show(conn, %{"slug" => slug}) do
    post = Artour.Public.get_post_by_slug!(slug)
    render(conn, "show.html", page_title: Artour.PostView.display_name(post), post: post, is_nsfw: post.is_nsfw, javascript: true, facebook_image: post.cover_image)
  end
end
