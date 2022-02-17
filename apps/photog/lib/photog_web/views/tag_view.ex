defmodule PhotogWeb.TagView do
  use PhotogWeb, :view
  alias PhotogWeb.TagView
  alias Photog.Api.Image

  def render("index.json", %{tags: tags}) do
    %{data: render_many(tags, TagView, "tag_excerpt.json")}
  end

  def render("index_with_cover_image.json", %{tags: tags}) do
    %{data: render_many(tags, TagView, "tag_excerpt_with_cover_image.json")}
  end

  def render("show.json", %{tag: tag}) do
    %{data: render_one(tag, TagView, "tag.json")}
  end

  def render("show_excerpt.json", %{tag: tag}) do
    %{data: render_one(tag, TagView, "tag_excerpt.json")}
  end

  def render("tag.json", %{tag: tag}) do
    %{
      id: tag.id,
      name: tag.name,
      is_favorite: tag.is_favorite,
      cover_album_id: tag.cover_album_id,
      albums_count: tag.albums_count,
    }
  end

  def render("tag_excerpt.json", %{tag: tag}) do
    tag_excerpt(tag)
  end

  def render("tag_excerpt_with_cover_image.json", %{tag: tag}) do
    cover_image = case tag.cover_image do
      %Image{} -> %{
        mini_thumbnail_path: tag.cover_image.mini_thumbnail_path,
      }
      _ -> nil
    end

    %{
      id: tag.id,
      name: tag.name,
      is_favorite: tag.is_favorite,
      cover_image: cover_image,
      items_count: tag.albums_count
    }
  end

  def tag_excerpt(tag) do
    %{
      id: tag.id,
      name: tag.name,
      is_favorite: tag.is_favorite,
    }
  end

end
