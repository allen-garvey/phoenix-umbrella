defmodule Artour.ApiPostImageView do
  use Artour.Web, :view

  @doc """
  Renders individual post image instance to json
  key has to be api_post_image, not post_image, because that is how
  render_many and render work by default
  """
  def render("post_image.json", %{api_post_image: post_image}) do
    %{
      id: post_image.id,
      # post_id: post_image.post_id,
      order: post_image.order,
      caption: post_image.caption,
      image: Artour.ApiImageView.render("image_thumbnail_excerpt.json", api_image: post_image.image),
      url: %{
        # show: post_image_path(Artour.Endpoint, :show, post_image),
        edit: post_image_path(Artour.Endpoint, :edit, post_image),
      },
    }
  end
end
