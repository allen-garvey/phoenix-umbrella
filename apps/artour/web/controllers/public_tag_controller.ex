defmodule Artour.PublicTagController do
  use Artour.Web, :controller

  alias Artour.Public

  def index(conn, _params) do
    tags = Public.tags_with_posts()
    render conn, "index.html", page_title: "Tags",  tags: tags
  end

  def show(conn, %{"slug" => slug}) do
    tag = Public.get_tag_by_slug!(slug)
    render conn, "show.html", page_title: Artour.TagView.display_name(tag),  tag: tag 
  end

end
