defmodule Artour.ApiPostController do
  use Artour.Web, :controller

  alias Artour.Api

  @doc """
  Update attributes of post
  right now only used for cover_image_id
  """
  def update(conn, %{"post_id" => post_id, "cover_image_id" => cover_image_id}) do
    Api.update_post_cover_image(post_id, cover_image_id)
    |> post_updated(put_view(conn, CommonWeb.ApiGenericView))
  end

  defp post_updated(:ok, conn) do
    render(conn, "ok.json", message: "Post cover_image_id updated")
  end

  defp post_updated(:error, conn) do
    conn
    |> put_status(:internal_server_error)
    |> render("error.json", message: "Error changing post cover_image_id")
  end

  @doc """
  Returns list of all of a post's images
  export=true param used for personal website
  """
  def post_images(conn, %{"post_id" => post_id, "export" => "true"}) do
    post_images = Api.list_post_images_for_post(post_id)
    render(conn, "post_images_list_export.json", post_images: post_images)
  end
  
  def post_images(conn, %{"post_id" => post_id}) do
    post_images = Api.list_post_images_for_post(post_id)
    render(conn, "post_images_list.json", post_images: post_images)
  end


  @doc """
  Reorder post album images
  """
  def reorder_images(conn, %{"post_id" => _post_id, "post_images" => post_images}) do
    Api.reorder_post_images(post_images)
    conn 
    |> put_view(CommonWeb.ApiGenericView)
    |> render("ok.json", message: "Post image order updated")
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
