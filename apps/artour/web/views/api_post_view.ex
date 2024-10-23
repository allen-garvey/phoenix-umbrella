defmodule Artour.ApiPostView do
  use Artour.Web, :view

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
    %{data: render_many(post_images, Artour.ApiPostImageView, "post_image.json")}
  end


end
