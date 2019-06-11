defmodule Bookmarker.ApiTagView do
  use Bookmarker.Web, :view
  alias Bookmarker.ApiTagView
  alias Bookmarker.Router.Helpers, as: Routes

  def render("tags.json", %{tags: tags}) do
    %{
      data: render_many(tags, ApiTagView, "tag_excerpt.json")
    }
  end

  # has to be api_tag for render_many to work
  def render("tag_excerpt.json", %{api_tag: tag}) do
    tag_excerpt(tag)
  end

  def tag_excerpt(tag) do
    %{
      id: tag.id,
      name: tag.name,
      urls: %{
        show: Routes.tag_path(Bookmarker.Endpoint, :show, tag.id)
      }
    }
  end
end
