defmodule PhotogWeb.AlbumTagView do
  use PhotogWeb, :view
  alias PhotogWeb.AlbumTagView

  def render("index.json", %{album_tags: album_tags}) do
    %{data: render_many(album_tags, AlbumTagView, "album_tag.json")}
  end

  def render("show.json", %{album_tag: album_tag}) do
    %{data: render_one(album_tag, AlbumTagView, "album_tag.json")}
  end

  def render("album_tag.json", %{album_tag: album_tag}) do
    %{id: album_tag.id,
      album_order: album_tag.album_order,
      album_id: album_tag.album_id,
      tag_id: album_tag.tag_id,
    }
  end
end
