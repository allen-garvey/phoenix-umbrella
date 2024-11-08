defmodule Artour.ApiPostView do
  use Artour.Web, :view

  alias Artour.ImageView

  @doc """
  Used to get images that can be added to post
  """
  def render("image_excerpts.json", %{images: images}) do
    %{data: render_many(images, Artour.ApiImageView, "image_thumbnail_excerpt.json")}
  end

  @doc """
  Used to get a post's post images
  """
  def render("post_images_list.json", %{post_images: post_images}) do
    %{data: Enum.map(post_images, &post_image_to_map/1)}
  end

  @doc """
  Used to get a post's post images for personal website model
  """
  def render("post_images_list_export.json", %{post_images: post_images}) do
    Enum.map(post_images, &post_image_export_to_map/1)
  end

  defp post_image_to_map(post_image) do
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

  defp post_image_export_to_map(post_image) do
    image = post_image.image
    
    %{
      id: image.id,
      caption: post_image.caption,
      description: image.description,
      url: %{
        large: ImageView.url_for(Artour.Endpoint, image, :large),
        medium: ImageView.url_for(Artour.Endpoint, image, :medium),
        small: ImageView.url_for(Artour.Endpoint, image, :small),
        thumbnail: ImageView.url_for(Artour.Endpoint, image, :thumbnail),
      },
    }
  end
end
