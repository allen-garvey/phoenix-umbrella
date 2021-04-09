defmodule PhotogWeb.AlbumView do
  use PhotogWeb, :view
  alias PhotogWeb.AlbumView
  alias PhotogWeb.ImageView
  alias PhotogWeb.TagView

  def render("index.json", %{albums: albums}) do
    %{data: render_many(albums, AlbumView, "album_excerpt.json")}
  end

  def render("index_excerpt.json", %{albums: albums}) do
    %{data: render_many(albums, AlbumView, "album_excerpt_mini.json")}
  end

  def render("show.json", %{album: album}) do
    %{data: render_one(album, AlbumView, "album.json")}
  end

  def render("show_excerpt_mini.json", %{album: album}) do
    %{data: render_one(album, AlbumView, "album_excerpt_mini.json")}
  end

  def render("album_excerpt.json",   %{album: {album, count}}) do
    %{
      id: album.id,
      name: album.name,
      items_count: count,
      cover_image: ImageView.image_to_map(album.cover_image),
    }
  end

  def render("album_excerpt_mini.json", %{album: album}) do
    album_excerpt_mini_to_map(album)
  end

  def render("album.json", %{album: album}) do
    %{id: album.id,
      name: album.name,
      description: album.description,
      cover_image: ImageView.image_to_map(album.cover_image),
      images: Enum.map(album.images, &ImageView.image_full_to_map/1),
      tags: Enum.map(album.tags, &TagView.tag_excerpt/1)
    }
  end

  def album_excerpt_to_map(album) do
    %{
      id: album.id,
      name: album.name,
      cover_image: ImageView.image_to_map(album.cover_image),
    }
  end

  def album_excerpt_mini_to_map(album) do
    %{
      id: album.id,
      name: album.name,
    }
  end
end
