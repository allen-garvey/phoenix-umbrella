defmodule Artour.ApiPostController do
  use Artour.Web, :controller

  alias Artour.Api
  alias Artour.Admin

  @doc """
  Returns list of all tags unused by a post
  """
  def tags_for(conn, %{"post_id" => post_id, "unused" => "true"}) do
    tags = Api.unused_tags_for_post(post_id)
    render(conn, "tags_list.json", tags: tags)
  end

  def tags_for(conn, %{"post_id" => post_id}) do
    tags = Api.tags_for_post(post_id)
    render(conn, "tags_list.json", tags: tags)
  end

  @doc """
  Adds tags to a post
  tags json list of tag ids
  """
  def add_tags(conn, %{"post_id" => post_id, "tags" => tags}) do
    Api.create_post_tags(post_id, tags)
    render(conn, "ok.json", message: "Tags added to post")
  end

  @doc """
  Removes a tag from a post
  """
  def remove_tag(conn, %{"post_id" => post_id, "tag_id" => tag_id}) do
    Admin.delete_post_tag(post_id, tag_id)
    render(conn, "ok.json", message: "Post tag deleted")
  end

  @doc """
  Update attributes of post
  right now only used for cover_image_id
  """
  def update(conn, %{"post_id" => post_id, "cover_image_id" => cover_image_id}) do
    case Api.update_post_cover_image(post_id, cover_image_id) do
      :ok    -> render(conn, "ok.json", message: "Post cover_image_id updated")
      :error -> render(conn, "error.json", message: "Error changing post cover_image_id")
    end
  end

  @doc """
  Returns list of all of a post's images
  """
  def post_images(conn, %{"post_id" => post_id}) do
    post_images = Api.list_post_images_for_post(post_id)
    render(conn, "post_images_list.json", post_images: post_images)
  end

  @doc """
  Reorder post album images
  """
  def reorder_images(conn, %{"post_id" => _post_id, "post_images" => post_images}) do
    Api.reorder_post_images(post_images)
    render(conn, "ok.json", message: "Post image order updated")
   end

  @doc """
  Gets images that are unused, either for a given post or that are unused altogether
  """
  def addable_images(conn, %{"post" => _post_id, "unused" => "true"}) do
    unused_images = Api.unused_images()
    render(conn, "image_excerpts.json", images: unused_images)
  end

  def addable_images(conn, %{"post" => post_id}) do
    unused_images = Api.unused_images_for_post(post_id)
    render(conn, "image_excerpts.json", images: unused_images)
  end

end
