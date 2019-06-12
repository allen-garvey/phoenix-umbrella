defmodule SerenWeb.AlbumView do
  use SerenWeb, :view
  alias SerenWeb.AlbumView

  def render("index.json", %{albums: albums}) do
    %{data: render_many(albums, AlbumView, "album.json")}
  end

  def render("show.json", %{album: album}) do
    %{data: render_one(album, AlbumView, "album.json")}
  end

  def render("album.json", %{album: album}) do
    %{
      id: album.id,
      title: album.title,
      artist_id: album.artist_id,
    }
  end
end
