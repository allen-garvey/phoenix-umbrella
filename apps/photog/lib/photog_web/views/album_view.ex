defmodule PhotogWeb.AlbumView do
  use PhotogWeb, :view
  alias PhotogWeb.AlbumView
  alias PhotogWeb.ImageView
  alias PhotogWeb.TagView

  def render("index.json", %{albums: albums}) do
    %{data: Enum.map(albums, &album_excerpt_to_map/1)}
  end

  def render("index_for_tags.json", %{albums: albums}) do
    %{data: Enum.map(albums, &album_excerpt_tag_to_map/1)}
  end

  def render("index_excerpt.json", %{albums: albums}) do
    %{data: render_many(albums, AlbumView, "album_excerpt_mini.json")}
  end

  def render("show.json", %{album: album, persons: persons}) do
    %{data: 
      %{
        id: album.id,
        name: album.name,
        description: album.description,
        year: album.year,
        is_favorite: album.is_favorite,
        images_count: album.images_count,
        cover_image: %{
          id: album.cover_image.id,
        },
        tags: Enum.map(album.tags, &TagView.tag_excerpt/1),
        persons: persons,
      }
    }
  end

  def render("show_excerpt_mini.json", %{album: album}) do
    %{data: render_one(album, AlbumView, "album_excerpt_mini.json")}
  end

  def render("album_excerpt_mini.json", %{album: album}) do
    album_excerpt_mini_to_map(album)
  end

  defp album_excerpt_to_map(album) do
    %{
      id: album.id,
      name: album.name,
      is_favorite: album.is_favorite,
      cover_image: ImageView.image_thumbnail_to_map(album.cover_image),
      items_count: album.images_count,
    }
  end

  defp album_excerpt_tag_to_map(album) do
    album_excerpt_to_map(album)
    |> Map.put(:year, album.year)
  end

  def album_excerpt_mini_to_map(album) do
    %{
      id: album.id,
      name: album.name,
      is_favorite: album.is_favorite,
    }
  end

end
