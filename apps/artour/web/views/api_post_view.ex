defmodule Artour.ApiPostView do
  use Artour.Web, :view

  @doc """
  Generic ok message, such as for when something is deleted successfully
  """
  def render("ok.json", %{message: message}) do
    %{data: message}
  end

  @doc """
  Generic error message, such as for when there is an error
  """
  def render("error.json", %{message: message}) do
    %{error: message}
  end

  @doc """
  Used to get all tags for a specific post
  """
  def render("tags_list.json", %{tags: tags}) do
    %{data: render_many(tags, Artour.ApiTagView, "tag.json")}
  end

  # def render("show.json", %{api_post: api_post}) do
  #   %{data: render_one(api_post, Artour.ApiPostView, "api_post.json")}
  # end

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
