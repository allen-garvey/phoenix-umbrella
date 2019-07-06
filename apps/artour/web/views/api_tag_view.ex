defmodule Artour.ApiTagView do
  use Artour.Web, :view

  @doc """
  Renders individual tag instance to json
  key has to be api_tag, not tag, because that is how
  render_many and render work by default
  """
  def render("tag.json", %{api_tag: tag}) do
    %{
      id: tag.id,
      name: tag.name
    }
  end
end
