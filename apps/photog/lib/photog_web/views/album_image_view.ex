defmodule PhotogWeb.AlbumImageView do
  use PhotogWeb, :view
  alias PhotogWeb.AlbumImageView

  def render("index.json", %{album_images: album_images}) do
    %{data: render_many(album_images, AlbumImageView, "album_image.json")}
  end

  def render("show.json", %{album_image: album_image}) do
    %{data: render_one(album_image, AlbumImageView, "album_image.json")}
  end

  def render("album_image.json", %{album_image: album_image}) do
    %{
      id: album_image.id,
      image_order: album_image.image_order,
      image_id: album_image.image_id,
      album_id: album_image.album_id,
    }
  end
end
