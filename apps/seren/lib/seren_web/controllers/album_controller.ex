defmodule SerenWeb.AlbumController do
  use SerenWeb, :controller

  alias Seren.Player
  alias Seren.Player.Album

  action_fallback SerenWeb.FallbackController

  def index(conn, _params) do
    albums = Player.list_albums()
    render(conn, "index.json", albums: albums)
  end

  def tracks_for(conn, %{"id" => id}) do
    tracks = Player.tracks_for_album(id)
    conn
      |> put_view(SerenWeb.TrackView)
      |> SerenWeb.TrackController.index_page(tracks)
  end

  def create(conn, %{"album" => album_params}) do
    with {:ok, %Album{} = album} <- Player.create_album(album_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", album_path(conn, :show, album))
      |> render("show.json", album: album)
    end
  end

  def show(conn, %{"id" => id}) do
    album = Player.get_album!(id)
    render(conn, "show.json", album: album)
  end

  def update(conn, %{"id" => id, "album" => album_params}) do
    album = Player.get_album!(id)

    with {:ok, %Album{} = album} <- Player.update_album(album, album_params) do
      render(conn, "show.json", album: album)
    end
  end

  def delete(conn, %{"id" => id}) do
    album = Player.get_album!(id)
    with {:ok, %Album{}} <- Player.delete_album(album) do
      send_resp(conn, :no_content, "")
    end
  end
end
